import 'dart:io';
import 'package:aws3_bucket/aws3_bucket.dart';
import 'package:aws3_bucket/aws_region.dart';
import 'package:aws3_bucket/iam_crediental.dart';
import 'package:aws3_bucket/image_data.dart';
// import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:flutter/material.dart';

class SurveyImageToServerService {
  Future<String?> uploadSurveyImageToServer(
      File imageFile, String fileName) async {
    try {
      // var response = await AwsS3.uploadFile(
      //     accessKey: "AKIARUYJYFCSRJUWGKQY",
      //     secretKey: "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",
      //     file: imageFile,
      //     bucket: "assignments-list",
      //     region: "ap-south-1",
      //     filename: fileName);
      IAMCrediental iamCrediental = IAMCrediental(
          secretId: "AKIARUYJYFCSRJUWGKQY",
          secretKey: "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");

      ImageData imageData = ImageData(fileName, imageFile.path,
          imageUploadFolder: "PolarisSurvey");
      var response = await Aws3Bucket.upload("assignments-list",
          AwsRegion.AP_SOUTH_1, AwsRegion.AP_SOUTH_1, imageData, iamCrediental);
      return response;
    } catch (e) {
      debugPrint("Error uploading $e");
      return null;
    }
  }
}
