import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_assignment/core/helpers/widgets_and_attributes.dart';
import 'package:polaris_assignment/models/form_data.dart';
import 'package:polaris_assignment/models/survey_form_model.dart';
import 'package:polaris_assignment/view/cubit/home_cubit.dart';
import 'package:polaris_assignment/view/global_widgets/custom_radio_button.dart';
import 'package:polaris_assignment/view/ui/widgets/survey_component_heading_widget.dart';
import 'package:polaris_assignment/view/ui/widgets/validation_error_widget.dart';

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
                type: "RadioGroup");
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
