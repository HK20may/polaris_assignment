import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_assignment/core/widgets/toast.dart';
import 'package:polaris_assignment/data/enums/component_type_enum.dart';
import 'package:polaris_assignment/data/models/form_data/form_data.dart';
import 'package:polaris_assignment/data/models/form_data_field/form_data_field.dart';
import 'package:polaris_assignment/data/models/survey_form_model.dart';
import 'package:polaris_assignment/domain/use_case/get_form_data.dart';
import 'package:polaris_assignment/domain/use_case/on_click_submit.dart';

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
    try {
      surveyFormData = await GetFormData().onExecute();
    } catch (e) {
      Toast.error("Something went wrong");
      debugPrint(e.toString());
    }

    _initializingFetchedData();
    emit(SurveyFormData(surveyFormData: surveyFormData ?? SurveyForm()));
  }

  ///To post data using the background thread
  Future<void> postSurveyData() async {
    OnClickSubmit().onExecute(
      surveyFormData?.formName ?? "",
      formFields,
      allFieldLabels,
    );
    _clearFields();
    _initializingFetchedData();
    Toast.info("Form Submitted Successfully");
    emit(SurveyFormUploadSuccess(id: DateTime.now()));
  }

  ///initializing local variable
  void _initializingFetchedData() {
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

  ///clearing fields after submission
  void _clearFields() {
    storedData.clear();
    allFieldLabels.clear();
  }
}
