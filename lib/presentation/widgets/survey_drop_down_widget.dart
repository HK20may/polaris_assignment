import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_assignment/core/widgets/custom_drop_down_menu.dart';
import 'package:polaris_assignment/data/enums/component_type_enum.dart';
import 'package:polaris_assignment/data/models/form_data_field/form_data_field.dart';
import 'package:polaris_assignment/data/models/survey_form_model.dart';
import 'package:polaris_assignment/presentation/cubit/home_cubit.dart';
import 'package:polaris_assignment/presentation/widgets/survey_component_heading_widget.dart';
import 'package:polaris_assignment/presentation/widgets/validation_error_widget.dart';

class SurveyDropDownWidget extends StatelessWidget {
  final MetaInfo? metaInfo;
  const SurveyDropDownWidget({super.key, required this.metaInfo});

  @override
  Widget build(BuildContext context) {
    var homeCubit = context.read<HomeCubit>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SurveyComponentHeadingWidget(metaInfo: metaInfo),
              CustomDropDownWidget(
                dropDownList: metaInfo?.options ?? [],
                initialSelected: homeCubit.storedData[metaInfo?.label ?? ""],
                selectedItem: (selectedValue) {
                  homeCubit.storedData[metaInfo?.label ?? ""] = selectedValue;
                  homeCubit.formFields[metaInfo?.label ?? ""] = FormDataField(
                      label: metaInfo?.label ?? "",
                      textValue: selectedValue,
                      type: ComponentTypeEnum.dropDown.componentName);
                },
              )
            ],
          ),
          if ((metaInfo?.mandatory?.toLowerCase() == 'yes') &&
              homeCubit.validationFailed &&
              (homeCubit.storedData[metaInfo?.label ?? ""] == null ||
                  homeCubit.storedData[metaInfo?.label ?? ""].isEmpty))
            const ValidationErrorWidget(),
        ],
      ),
    );
  }
}
