import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_assignment/core/theme/widgets_and_attributes.dart';
import 'package:polaris_assignment/core/widgets/custom_radio_button.dart';
import 'package:polaris_assignment/data/enums/component_type_enum.dart';
import 'package:polaris_assignment/data/models/form_data_field/form_data_field.dart';
import 'package:polaris_assignment/data/models/survey_form_model.dart';
import 'package:polaris_assignment/presentation/cubit/home_cubit.dart';
import 'package:polaris_assignment/presentation/widgets/survey_component_heading_widget.dart';
import 'package:polaris_assignment/presentation/widgets/validation_error_widget.dart';

class SurveyRadioButtonWidget extends StatelessWidget {
  final MetaInfo? metaInfo;
  const SurveyRadioButtonWidget({super.key, required this.metaInfo});

  @override
  Widget build(BuildContext context) {
    var homeCubit = context.read<HomeCubit>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyComponentHeadingWidget(metaInfo: metaInfo),
        sizedBoxH8,
        CustomRadioButtonWidget(
          radioButtonList: metaInfo?.options ?? [],
          selectedOption: homeCubit.storedData[metaInfo?.label ?? ""],
          selectedItem: (selectedOption) {
            homeCubit.storedData[metaInfo?.label ?? ""] = selectedOption;
            homeCubit.formFields[metaInfo?.label ?? ""] = FormDataField(
                label: metaInfo?.label ?? "",
                textValue: selectedOption,
                type: ComponentTypeEnum.radioGroup.componentName);
          },
        ),
        if ((metaInfo?.mandatory?.toLowerCase() == 'yes') &&
            homeCubit.validationFailed &&
            (homeCubit.storedData[metaInfo?.label ?? ""] == null ||
                homeCubit.storedData[metaInfo?.label ?? ""].isEmpty))
          const ValidationErrorWidget(),
        sizedBoxH8,
      ],
    );
  }
}
