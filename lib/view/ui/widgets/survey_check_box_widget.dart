import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_assignment/core/helpers/widgets_and_attributes.dart';
import 'package:polaris_assignment/models/check_box_field_model.dart';
import 'package:polaris_assignment/models/form_data.dart';
import 'package:polaris_assignment/models/survey_form_model.dart';
import 'package:polaris_assignment/view/cubit/home_cubit.dart';
import 'package:polaris_assignment/view/global_widgets/custom_check_box.dart';
import 'package:polaris_assignment/view/ui/widgets/survey_component_heading_widget.dart';
import 'package:polaris_assignment/view/ui/widgets/validation_error_widget.dart';

class SurveyCheckBoxWidget extends StatelessWidget {
  final MetaInfo? metaInfo;
  const SurveyCheckBoxWidget({super.key, required this.metaInfo});

  @override
  Widget build(BuildContext context) {
    var homeCubit = context.read<HomeCubit>();
    CheckboxField checkboxField = CheckboxField(
        label: metaInfo?.label ?? "",
        options: metaInfo?.options ?? [],
        selectedOptions: homeCubit.storedData[metaInfo?.label ?? ""] ?? []);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyComponentHeadingWidget(metaInfo: metaInfo),
        sizedBoxH4,
        CustomCheckBox(
          checkboxField: checkboxField,
          selectedItemsListFunction: (checkboxField) {
            homeCubit.storedData[checkboxField.label] =
                checkboxField.selectedOptions;

            homeCubit.formFields[metaInfo?.label ?? ""] = FormDataField(
                label: metaInfo?.label ?? "",
                checkBoxValue: checkboxField.selectedOptions,
                type: "CheckBoxes");
          },
        ),
        if ((metaInfo?.mandatory?.toLowerCase() == 'yes') &&
            homeCubit.validationFailed &&
            (homeCubit.storedData[metaInfo?.label ?? ""] == null ||
                homeCubit.storedData[metaInfo?.label ?? ""].isEmpty))
          const ValidationErrorWidget(),
        sizedBoxH4,
      ],
    );
  }
}
