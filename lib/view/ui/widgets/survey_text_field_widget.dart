// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_assignment/core/helpers/widgets_and_attributes.dart';
import 'package:polaris_assignment/models/form_data.dart';
import 'package:polaris_assignment/models/survey_form_model.dart';
import 'package:polaris_assignment/view/cubit/home_cubit.dart';
import 'package:polaris_assignment/view/global_widgets/custom_text_field.dart';
import 'package:polaris_assignment/view/ui/widgets/survey_component_heading_widget.dart';
import 'package:polaris_assignment/view/ui/widgets/validation_error_widget.dart';

class SurveyTextFieldWidget extends StatelessWidget {
  final MetaInfo? metaInfo;
  SurveyTextFieldWidget({super.key, required this.metaInfo});

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var homeCubit = context.read<HomeCubit>();
    _textEditingController = TextEditingController(
        text: homeCubit.storedData[metaInfo?.label ?? ""] ?? "");
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyComponentHeadingWidget(metaInfo: metaInfo),
        sizedBoxH16,
        CustomTextField(
          labelText: metaInfo?.label ?? "",
          controller: _textEditingController,
          keyboardType: metaInfo?.componentInputType == "INTEGER"
              ? TextInputType.number
              : null,
          isNumber: metaInfo?.componentInputType == "INTEGER" ? true : false,
          maxLength: metaInfo?.componentInputType == "INTEGER" ? 10 : null,
          textWatcher: (value) {
            homeCubit.storedData[metaInfo?.label ?? ""] = value;
            homeCubit.formFields[metaInfo?.label ?? ""] = FormDataField(
                label: metaInfo?.label ?? "",
                textValue: value,
                type: "EditText");
          },
        ),
        sizedBoxH4,
        if ((metaInfo?.mandatory?.toLowerCase() == 'yes') &&
            homeCubit.validationFailed &&
            (homeCubit.storedData[metaInfo?.label ?? ""] == null ||
                context
                    .read<HomeCubit>()
                    .storedData[metaInfo?.label ?? ""]
                    .isEmpty))
          const ValidationErrorWidget(),
        sizedBoxH16,
      ],
    );
  }
}
