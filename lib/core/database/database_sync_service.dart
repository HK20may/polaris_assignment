import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:polaris_assignment/core/database/database_setup.dart';
import 'package:polaris_assignment/core/isolate/worker/image_upload_worker.dart';
import 'package:polaris_assignment/core/isolate/worker/survey_upload_worker.dart';
import 'package:polaris_assignment/enums/component_type_enum.dart';
import 'package:polaris_assignment/models/form_data.dart';
import 'package:polaris_assignment/models/gallery_image.dart';

class DatabaseSyncService {
  Future<void> doWork(String path, SendPort port) async {
    debugPrint("Database Sync Started");

    Hive.registerAdapter(FormDataAdapter());
    Hive.registerAdapter(FormDataFieldAdapter());
    Hive.registerAdapter(GalleryImageAdapter());
    await DatabaseSetup.setUpHive(path);

    debugPrint("Database Setup Done");

    var surveyFormDb = Hive.box("survey_form_database");

    List<FormData> formDataList =
        surveyFormDb.values.map((dynamic value) => value as FormData).toList();

    debugPrint("Number of Forms added to DB ${surveyFormDb.length}");

    for (int i = 0; i < formDataList.length; i++) {
      debugPrint("Uploading Image to Server");
      //uploading all the images to AWS server
      for (int j = 0; j < formDataList[i].submittedFields!.length; j++) {
        if (formDataList[i].submittedFields?[j].type ==
            ComponentTypeEnum.captureImages.componentName) {
          formDataList[i].submittedFields?[j].galleryImagesUrl =
              await ImageUploadWorker().doWork(
                  formDataList[i].submittedFields?[j].galleryImages ?? []);

          log("Updated List check ${formDataList[i].submittedFields?[j].galleryImagesUrl}");
        }
        debugPrint("ImageUploadWorker done");
      }

      //converting the list to map
      Map<String, dynamic> resultMap = {};

      if (formDataList[i].submittedFields != null) {
        for (FormDataField field in formDataList[i].submittedFields ?? []) {
          if (field.type == ComponentTypeEnum.editText.componentName ||
              field.type == ComponentTypeEnum.dropDown.componentName ||
              field.type == ComponentTypeEnum.radioGroup.componentName) {
            resultMap[field.label!] = field.textValue;
          } else if (field.type == ComponentTypeEnum.checkBoxes.componentName) {
            resultMap[field.label!] = field.checkBoxValue;
          } else if (field.type ==
              ComponentTypeEnum.captureImages.componentName) {
            resultMap[field.label!] = field.galleryImagesUrl;
          }
        }
      }

      debugPrint("Posting data to Server");

      //posting the the data
      await SurveyUploadWorker()
          .doWork(resultMap)
          .then((value) => debugPrint("SurveyUploadWorker done"));
    }

    surveyFormDb.clear();
    port.send(true);
    debugPrint("Database Cleared");
  }
}
