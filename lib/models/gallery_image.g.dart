// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GalleryImageAdapter extends TypeAdapter<GalleryImage> {
  @override
  final int typeId = 3;

  @override
  GalleryImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GalleryImage(
      imageId: fields[0] as String?,
      blobImage: fields[1] as Uint8List?,
      pictureName: fields[2] as String?,
      picturePath: fields[3] as String?,
      imageUrl: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GalleryImage obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.imageId)
      ..writeByte(1)
      ..write(obj.blobImage)
      ..writeByte(2)
      ..write(obj.pictureName)
      ..writeByte(3)
      ..write(obj.picturePath)
      ..writeByte(4)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GalleryImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
