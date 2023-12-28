import 'package:polaris_assignment/data/datasources/survey_image_to_server_source.dart';
import 'package:polaris_assignment/data/models/gallery_image/gallery_image.dart';

class ImageUploadWorker {
  /// Starts to [doWork] ie upload image to server in the background
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
