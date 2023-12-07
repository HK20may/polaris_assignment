import 'dart:convert';
import 'dart:io';

class GalleryImage {
  String? imageId;
  File? file;
  String? pictureName;
  String? picturePath;
  String? imageUrl;

  GalleryImage({
    this.imageId,
    this.file,
    this.pictureName,
    this.picturePath,
    this.imageUrl,
  });

  GalleryImage copyWith({
    String? imageId,
    File? file,
    String? pictureName,
    String? picturePath,
    String? imageUrl,
  }) {
    return GalleryImage(
      imageId: imageId ?? this.imageId,
      file: file ?? this.file,
      pictureName: pictureName ?? this.pictureName,
      picturePath: picturePath ?? this.picturePath,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageId': imageId,
      'file': file?.path, // Convert File to its path
      'pictureName': pictureName,
      'picturePath': picturePath,
      'imageUrl': imageUrl,
    };
  }

  factory GalleryImage.fromMap(Map<String, dynamic> map) {
    return GalleryImage(
      imageId: map['imageId'],
      file: map['file'] != null
          ? File(map['file'])
          : null, // Convert path back to File
      pictureName: map['pictureName'],
      picturePath: map['picturePath'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GalleryImage.fromJson(String source) =>
      GalleryImage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GalleryImage(imageId: $imageId, file: $file, pictureName: $pictureName, picturePath: $picturePath, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GalleryImage &&
        other.imageId == imageId &&
        other.file == file &&
        other.pictureName == pictureName &&
        other.picturePath == picturePath &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return imageId.hashCode ^
        file.hashCode ^
        pictureName.hashCode ^
        picturePath.hashCode ^
        imageUrl.hashCode;
  }
}
