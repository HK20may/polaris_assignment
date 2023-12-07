import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:polaris_assignment/core/utils/shared_preference/shared_preference_constant.dart';
import 'package:polaris_assignment/core/utils/shared_preference/shared_preference_helper.dart';
import 'package:polaris_assignment/models/gallery_image_model.dart';
import 'package:polaris_assignment/view_model/service/survey_image_to_server_service.dart';

class ImageUploadWorker {
  /// Starts to [doWork] in the background
  Future<void> doWork() async {
    if (PreferenceHelper.getJson(
            SharedPreferenceConstant.CAPTURE_IMAGE_DATA, "") !=
        "") {
      Map<String, dynamic> imageData = PreferenceHelper.getJson(
          SharedPreferenceConstant.CAPTURE_IMAGE_DATA, "");
      await postImageData(imageData);
      // await UploadSurveyFormService().postSurveyFormData(storedData);
    }
  }

  /// [postImageData] push image to the server
  Future<void> postImageData(Map<String, dynamic> imageData) async {
    Map<String, dynamic> fetchedImageData = {};

    for (String key in imageData.keys) {
      List<GalleryImage> galleryImageList = [];
      for (int i = 0; i < imageData[key].length; i++) {
        // Check the type of the value
        if (imageData[key][i] is String) {
          // Convert the string to a Map
          Map<String, dynamic> imageMap = json.decode(imageData[key][i]);

          // Create a GalleryImage object
          GalleryImage galleryImage = GalleryImage.fromMap(imageMap);
          galleryImageList.add(galleryImage);
        } else {
          // Handle the case where the value is not a string
          debugPrint(
              "Unexpected data type for GalleryImage: ${imageData[key][i]}");
        }
      }
      List<String> imageUrl = [];
      for (int j = 0; j < galleryImageList.length; j++) {
        var response = await SurveyImageToServerService()
                .uploadSurveyImageToServer(galleryImageList[j].file!,
                    galleryImageList[j].pictureName!) ??
            "";

        imageUrl.add(response);
      }
      fetchedImageData[key] = imageUrl;
    }

    await PreferenceHelper.setJson(
        SharedPreferenceConstant.FETCHED_IMAGE_DATA, fetchedImageData);
  }
}
