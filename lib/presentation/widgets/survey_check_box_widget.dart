import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_assignment/core/theme/widgets_and_attributes.dart';
import 'package:polaris_assignment/core/widgets/custom_check_box.dart';
import 'package:polaris_assignment/data/enums/component_type_enum.dart';
import 'package:polaris_assignment/data/models/form_data_field/form_data_field.dart';
import 'package:polaris_assignment/domain/entity/check_box_field.dart';
import 'package:polaris_assignment/data/models/survey_form_model.dart';
import 'package:polaris_assignment/presentation/cubit/home_cubit.dart';
import 'package:polaris_assignment/presentation/widgets/survey_component_heading_widget.dart';
import 'package:polaris_assignment/presentation/widgets/validation_error_widget.dart';

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
                type: ComponentTypeEnum.checkBoxes.componentName);
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
