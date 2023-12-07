import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_assignment/core/helpers/constants.dart';
import 'package:polaris_assignment/core/isolate/background_thread.dart';
import 'package:polaris_assignment/core/utils/shared_preference/shared_preference_constant.dart';
import 'package:polaris_assignment/core/utils/shared_preference/shared_preference_helper.dart';
import 'package:polaris_assignment/core/utils/toast.dart';
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

      if (field.componentType == "RadioGroup") {
        storedData[label] = metaInfo?.options?[0] ?? "";
      }

      if (field.componentType == "DropDown") {
        storedData[label] = metaInfo?.options?[0] ?? "";
      }

      if (field.componentType == "CaptureImages") {
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
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      emit(SurveyFormUploadLoading());

      orderFormResponse();
      debugPrint(storedData.toString());

      //Uploading Image to server in the background thread
      Map<String, dynamic> captureImageMap = {};
      for (int i = 0; i < imagesForSurvey.length; i++) {
        captureImageMap[imagesForSurvey[i]] = storedData[imagesForSurvey[i]];
      }
      PreferenceHelper.setJson(
          SharedPreferenceConstant.CAPTURE_IMAGE_DATA, captureImageMap);

      await backgroundThread(Constants.IMAGE_UPLOAD_WORKER);

      //Assigning values fetched from posting images
      Map<String, dynamic> fetchedImageData = PreferenceHelper.getJson(
          SharedPreferenceConstant.FETCHED_IMAGE_DATA, "");

      for (String key in fetchedImageData.keys) {
        storedData[key] = fetchedImageData[key];
      }

      //Uploading Survey Data in the background thread
      PreferenceHelper.setJson(
          SharedPreferenceConstant.SURVEY_FORM_DATA, storedData);

      await backgroundThread(Constants.SURVEY_UPLOAD_WORKER);

      storedData.clear();
      initializingFetchedData();
      Toast.info("Form Submitted Successfully");
      emit(HomeInitial());
    } else {
      Toast.error("No Internet Connection Found.");
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
  }
}
