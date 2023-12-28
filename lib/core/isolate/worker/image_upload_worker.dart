import 'package:polaris_assignment/models/gallery_image.dart';
import 'package:polaris_assignment/view_model/service/survey_image_to_server_service.dart';

class ImageUploadWorker {
  /// Starts to [doWork] in the background
  Future<List<String>> doWork(List<GalleryImage> galleryImages) async {
    List<String> galleryImageUrl = [];
    await Future.forEach(galleryImages, (GalleryImage image) async {
      String imageUrl = await SurveyImageToServerService()
              .uploadSurveyImageToServer(
                  image.blobImage!, image.pictureName!, image.picturePath!) ??
          "";
      galleryImageUrl.add(imageUrl);
    });
    return galleryImageUrl;
  }
}
