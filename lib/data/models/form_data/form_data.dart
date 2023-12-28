import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:polaris_assignment/data/models/form_data_field/form_data_field.dart';

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
