// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FormDataAdapter extends TypeAdapter<FormData> {
  @override
  final int typeId = 0;

  @override
  FormData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormData(
      formName: fields[0] as String?,
      submittedFields: (fields[1] as List?)?.cast<FormDataField>(),
    );
  }

  @override
  void write(BinaryWriter writer, FormData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.formName)
      ..writeByte(1)
      ..write(obj.submittedFields);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FormDataFieldAdapter extends TypeAdapter<FormDataField> {
  @override
  final int typeId = 1;

  @override
  FormDataField read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormDataField(
      label: fields[0] as String?,
      type: fields[1] as String?,
      textValue: fields[2] as String?,
      checkBoxValue: (fields[3] as List?)?.cast<String>(),
      galleryImages: (fields[4] as List?)?.cast<GalleryImage>(),
      galleryImagesUrl: (fields[5] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, FormDataField obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.textValue)
      ..writeByte(3)
      ..write(obj.checkBoxValue)
      ..writeByte(4)
      ..write(obj.galleryImages)
      ..writeByte(5)
      ..write(obj.galleryImagesUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormDataFieldAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
