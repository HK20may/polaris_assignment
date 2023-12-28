import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:polaris_assignment/core/helpers/constants.dart';
import 'package:polaris_assignment/core/isolate/background_thread.dart';
import 'package:polaris_assignment/core/utils/toast.dart';
import 'package:polaris_assignment/enums/component_type_enum.dart';
import 'package:polaris_assignment/models/form_data.dart';
import 'package:polaris_assignment/models/survey_form_model.dart';
import 'package:polaris_assignment/view_model/service/survey_form_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  SurveyForm? surveyFormData;

  /// List of labels of all the fields
  List<String> allFieldLabels = [];

  /// List of labels of all the mandatory fields
  List<String> mandatoryFields = [];

  /// List of labels of fields having capture image
  List<String> imagesForSurvey = [];

  /// Map of storing all the typed data
  Map<String, dynamic> storedData = {};

  // variables for validation check
  bool isValidated = true;
  bool validationFailed = false;

  FormData currentFormData = FormData();
  Map<String, FormDataField> formFields = {};

  ///To fetch dynamic form data
  Future<void> fetchDynamicSurveyData() async {
    emit(SurveyFormLoading());
    surveyFormData = await SurveyFormService().fetchSurveyForm();

    initializingFetchedData();
    emit(SurveyFormData(surveyFormData: surveyFormData ?? SurveyForm()));
  }

  ///initializing local variable
  void initializingFetchedData() {
    for (var field in surveyFormData!.fields!) {
      var metaInfo = field.metaInfo;
      var label = metaInfo?.label ?? "";
      var mandatory = metaInfo?.mandatory ?? "";

      allFieldLabels.add(label);

      if (mandatory.toLowerCase() == 'yes') {
        mandatoryFields.add(label);
      }

      if (field.componentType == ComponentTypeEnum.radioGroup.componentName) {
        storedData[label] = metaInfo?.options?[0] ?? "";
        formFields[label] = FormDataField(
            label: label,
            textValue: metaInfo?.options?[0] ?? "",
            type: ComponentTypeEnum.radioGroup.componentName);
      }

      if (field.componentType == ComponentTypeEnum.dropDown.componentName) {
        storedData[label] = metaInfo?.options?[0] ?? "";
        formFields[label] = FormDataField(
            label: label,
            textValue: metaInfo?.options?[0] ?? "",
            type: ComponentTypeEnum.dropDown.componentName);
      }

      if (field.componentType ==
          ComponentTypeEnum.captureImages.componentName) {
        imagesForSurvey.add(label);
      }
    }
    debugPrint(mandatoryFields.toString());
  }

  ///For checking validation of the fields
  void checkValidation() {
    validationFailed = false;
    for (int i = 0; i < mandatoryFields.length; i++) {
      if (storedData[mandatoryFields[i]] == null ||
          storedData[mandatoryFields[i]].isEmpty) {
        validationFailed = true;
        isValidated = !isValidated;
        emit(SurveyFormError(storedData: storedData, isValidated: isValidated));
        break;
      }
    }
    if (!validationFailed) {
      emit(HomeInitial());
    }
  }

  ///To post data using the background thread
  Future<void> postSurveyData() async {
    var surveyFormDb = Hive.box("survey_form_database");
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      emit(SurveyFormUploadLoading());

      orderFormResponse();
      debugPrint(storedData.toString());

      List<FormDataField> submittedFields = formFields.values.toList();

      currentFormData = FormData(
          formName: surveyFormData?.formName ?? "",
          submittedFields: submittedFields);

      await surveyFormDb.add(currentFormData);

      backgroundThread(Constants.DATABASE_SYNC_SERVICE);

      clearFields();
      initializingFetchedData();
      Toast.info("Form Submitted Successfully");
      emit(SurveyFormUploadSuccess(id: DateTime.now()));
    } else {
      orderFormResponse();
      debugPrint(storedData.toString());

      List<FormDataField> submittedFields = formFields.values.toList();

      currentFormData = FormData(
          formName: surveyFormData?.formName ?? "",
          submittedFields: submittedFields);

      await surveyFormDb.add(currentFormData);

      clearFields();
      initializingFetchedData();
      Toast.info("Form Stored Locally Successfully");
      emit(SurveyFormUploadSuccess(id: DateTime.now()));
    }
  }

  ///Order the stored form response in the same order as fetched
  void orderFormResponse() {
    Map<String, dynamic> orderedData = {};
    for (var key in allFieldLabels) {
      if (storedData.containsKey(key)) {
        orderedData[key] = storedData[key];
      }
    }
    storedData = orderedData;
    Map<String, FormDataField> orderedFormFields = {
      for (var label in allFieldLabels) label: formFields[label]!
    };
    formFields = orderedFormFields;
  }

  ///clearing fields after submission
  void clearFields() {
    storedData.clear();
    // formFields.clear();
    // currentFormData.delete();
    allFieldLabels.clear();
  }
}
