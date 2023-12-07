import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polaris_assignment/core/helpers/widgets_and_attributes.dart';
import 'package:polaris_assignment/core/utils/toast.dart';
import 'package:polaris_assignment/models/gallery_image_model.dart';

class CustomImageTileWidget extends StatefulWidget {
  final int maxImageCount;
  final List<GalleryImage> selectedImages;
  final Function(List<GalleryImage>) onSelected;
  final String folderName;
  const CustomImageTileWidget(
      {super.key,
      required this.selectedImages,
      required this.onSelected,
      required this.maxImageCount,
      required this.folderName});

  @override
  State<CustomImageTileWidget> createState() => _CustomImageTileWidgetState();
}

class _CustomImageTileWidgetState extends State<CustomImageTileWidget> {
  List<GalleryImage> selectedPics = [];

  @override
  void initState() {
    selectedPics = widget.selectedImages;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedPics.isEmpty) {
      return InkWell(
        onTap: () async {
          await _captureImages();
          setState(() {
            widget.onSelected(selectedPics);
          });
        },
        child: SizedBox(
          height: 45,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8)),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_camera_back_outlined),
                sizedBoxW12,
                Text(
                  "Upload",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ),
      );
    }
    return AlignedGridView.count(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      crossAxisCount: 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 17,
      primary: false,
      shrinkWrap: true,
      itemCount: selectedPics.length,
      itemBuilder: (context, index) => GestureDetector(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              selectedPics[index].file!,
              fit: BoxFit.contain,
            ),
          ),
        ),
        onTap: () async {
          await _captureImages();

          setState(() {
            widget.onSelected(selectedPics);
          });
        },
      ),
    );
  }

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      await _captureImages();
    } else if (status.isDenied) {
      Permission.camera.request().then((status) async {
        if (status == PermissionStatus.granted) {
          await _captureImages();
        }
      });
    }
  }

  Future<void> _captureImages() async {
    List<GalleryImage> capturedImages = [];
    for (int j = 0; j < widget.maxImageCount; j++) {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image != null) {
        saveImage(File(image.path), widget.folderName, image.name);
        capturedImages.add(GalleryImage(
            file: File(image.path),
            pictureName: image.name,
            picturePath: image.path));
      }
    }
    if (capturedImages.isNotEmpty) {
      selectedPics = capturedImages;
    }
  }

  Future<void> saveImage(File image, String folderName, String fileName) async {
    try {
      final directory = await getExternalStorageDirectory();
      final folderPath = '${directory!.path}/$folderName';

      // Create the folder if it doesn't exist
      await Directory(folderPath).create(recursive: true);

      final filePath = '$folderPath/$fileName';

      // Copy the image to the specified path
      await image.copy(filePath);
      Toast.info("Image saved in $folderName folder");
      debugPrint('Image saved at: $filePath');
    } catch (e) {
      debugPrint('Error saving image: $e');
    }
  }
}
