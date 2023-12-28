import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'gallery_image.g.dart';

@HiveType(typeId: 3)
class GalleryImage extends HiveObject {
  @HiveField(0)
  final String? imageId;

  @HiveField(1)
  final Uint8List? blobImage;

  @HiveField(2)
  final String? pictureName;

  @HiveField(3)
  final String? picturePath;

  @HiveField(4)
  final String? imageUrl;

  GalleryImage({
    this.imageId,
    this.blobImage,
    this.pictureName,
    this.picturePath,
    this.imageUrl,
  });

  /// Converts the `GalleryImage` object to a `Map<String, dynamic>`.
  Map<String, dynamic> toMap() {
    return {
      'imageId': imageId,
      'blobImage': blobImage,
      'pictureName': pictureName,
      'picturePath': picturePath,
      'imageUrl': imageUrl,
    };
  }

  /// Creates a `GalleryImage` object from a `Map<String, dynamic>`.
  factory GalleryImage.fromMap(Map<dynamic, dynamic> map) {
    return GalleryImage(
      imageId: map['imageId'],
      blobImage: map['blobImage'],
      pictureName: map['pictureName'],
      picturePath: map['picturePath'],
      imageUrl: map['imageUrl'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GalleryImage &&
          imageId == other.imageId &&
          blobImage == other.blobImage &&
          pictureName == other.pictureName &&
          picturePath == other.picturePath &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode =>
      imageId.hashCode ^
      blobImage.hashCode ^
      pictureName.hashCode ^
      picturePath.hashCode ^
      imageUrl.hashCode;

  @override
  String toString() =>
      'GalleryImage(imageId: $imageId, blobImage: $blobImage, pictureName: $pictureName, picturePath: $picturePath, imageUrl: $imageUrl)';
}
