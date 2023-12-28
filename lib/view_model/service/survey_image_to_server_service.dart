import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:mime/mime.dart';
import 'package:aws_common/aws_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:polaris_assignment/core/common/aws_constants.dart';

class SurveyImageToServerService {
  Future<String?> uploadSurveyImageToServer(
      Uint8List imageFile, String fileName, String folderName) async {
    try {
      return await generatingAwsSignature(
          endpointUri: Uri.parse(buildFileUrlEndpoint(folderName, fileName)),
          file: imageFile);
    } catch (e) {
      debugPrint("Error uploading $e");
      return null;
    }
  }

  String buildFileUrlEndpoint(String filePathOnBucket, String fileName) =>
      'https://${AWSConstants.bucketName}.${AWSConstants.s3Service}.${AWSConstants.region}.amazonaws.com/$filePathOnBucket/$fileName';

  Future<String?> generatingAwsSignature({
    required Uri endpointUri,
    required Uint8List file,
  }) async {
    const signer = AWSSigV4Signer(
      credentialsProvider: AWSCredentialsProvider(
        AWSCredentials(
          AWSConstants.accessKeyId,
          AWSConstants.secretAccessKey,
          null,
          null,
        ),
      ),
    );
    final scope = AWSCredentialScope(
      region: AWSConstants.region,
      service: AWSService.s3,
    );
    final request = AWSHttpRequest(
      method: AWSHttpMethod.put,
      uri: endpointUri,
      headers: {
        AWSHeaders.contentType: lookupMimeType(endpointUri.toString()) ?? '',
      },
      body: file,
    );
    final signedRequest = await signer.sign(
      request,
      credentialScope: scope,
    );
    final resp = await signedRequest.send().response;
    if (resp.statusCode == 200) {
      debugPrint("Image Url: $endpointUri");
      return endpointUri.toString();
    }

    return null;
  }
}
