import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:polaris_assignment/models/gallery_image.dart';

part 'form_data.g.dart';

@HiveType(typeId: 0)
class FormData extends HiveObject {
  @HiveField(0)
  String? formName;

  @HiveField(1)
  List<FormDataField>? submittedFields;
  FormData({
    this.formName,
    this.submittedFields,
  });
  FormData copyWith({
    String? formName,
    List<FormDataField>? submittedFields,
  }) {
    return FormData(
      formName: formName ?? this.formName,
      submittedFields: submittedFields ?? this.submittedFields,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'formName': formName,
      'submittedFields': submittedFields?.map((x) => x.toMap()).toList(),
    };
  }

  factory FormData.fromMap(Map<String, dynamic> map) {
    return FormData(
      formName: map['formName'],
      submittedFields: List<FormDataField>.from(
          map['submittedFields']?.map((x) => FormDataField.fromMap(x))),
    );
  }
  String toJson() => json.encode(toMap());
  factory FormData.fromJson(String source) =>
      FormData.fromMap(json.decode(source));
  @override
  String toString() =>
      'FormData(formName: $formName, submittedFields: $submittedFields)';
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FormData &&
        other.formName == formName &&
        listEquals(other.submittedFields, submittedFields);
  }

  @override
  int get hashCode => formName.hashCode ^ submittedFields.hashCode;
}

@HiveType(typeId: 1)
class FormDataField extends HiveObject {
  @HiveField(0)
  String? label;

  @HiveField(1)
  String? type;

  @HiveField(2)
  String? textValue;

  @HiveField(3)
  List<String>? checkBoxValue;

  @HiveField(4)
  List<GalleryImage>? galleryImages;

  @HiveField(5)
  List<String>? galleryImagesUrl;
  FormDataField({
    this.label,
    this.type,
    this.textValue,
    this.checkBoxValue,
    this.galleryImages,
    this.galleryImagesUrl,
  });
  FormDataField copyWith({
    String? label,
    String? type,
    String? textValue,
    List<String>? checkBoxValue,
    List<String>? galleryImagesUrl,
    List<GalleryImage>? galleryImages,
  }) {
    return FormDataField(
      label: label ?? this.label,
      type: type ?? this.type,
      textValue: textValue ?? this.textValue,
      checkBoxValue: checkBoxValue ?? this.checkBoxValue,
      galleryImagesUrl: galleryImagesUrl ?? this.galleryImagesUrl,
      galleryImages: galleryImages ?? this.galleryImages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'type': type,
      'textValue': textValue,
      'checkBoxValue': checkBoxValue,
      'galleryImagesUrl': galleryImagesUrl,
      'galleryImages': galleryImages?.map((x) => x.toMap()).toList(),
    };
  }

  factory FormDataField.fromMap(Map<String, dynamic> map) {
    return FormDataField(
      label: map['label'],
      type: map['type'],
      textValue: map['textValue'],
      checkBoxValue: List<String>.from(map['checkBoxValue']),
      galleryImagesUrl: List<String>.from(map['galleryImagesUrl']),
      galleryImages: List<GalleryImage>.from(
          map['galleryImages']?.map((x) => GalleryImage.fromMap(x))),
    );
  }
  String toJson() => json.encode(toMap());
  factory FormDataField.fromJson(String source) =>
      FormDataField.fromMap(json.decode(source));
  @override
  String toString() {
    return 'SubmittedFields(label: $label, type: $type, textValue: $textValue, checkBoxValue: $checkBoxValue, galleryImages: $galleryImages, galleryImagesUrl: $galleryImagesUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FormDataField &&
        other.label == label &&
        other.type == type &&
        other.textValue == textValue &&
        listEquals(other.checkBoxValue, checkBoxValue) &&
        listEquals(other.galleryImagesUrl, galleryImagesUrl) &&
        listEquals(other.galleryImages, galleryImages);
  }

  @override
  int get hashCode {
    return label.hashCode ^
        type.hashCode ^
        textValue.hashCode ^
        checkBoxValue.hashCode ^
        galleryImagesUrl.hashCode ^
        galleryImages.hashCode;
  }
}
