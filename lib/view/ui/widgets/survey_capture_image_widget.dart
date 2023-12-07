import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_assignment/core/helpers/widgets_and_attributes.dart';
import 'package:polaris_assignment/models/survey_form_model.dart';
import 'package:polaris_assignment/view/cubit/home_cubit.dart';
import 'package:polaris_assignment/view/global_widgets/custom_image_tile.dart';
import 'package:polaris_assignment/view/ui/widgets/survey_component_heading_widget.dart';
import 'package:polaris_assignment/view/ui/widgets/validation_error_widget.dart';

class SurveyCaptureImageWidget extends StatelessWidget {
  final MetaInfo? metaInfo;
  const SurveyCaptureImageWidget({super.key, required this.metaInfo});

  @override
  Widget build(BuildContext context) {
    var homeCubit = context.read<HomeCubit>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SurveyComponentHeadingWidget(metaInfo: metaInfo),
        sizedBoxH16,
        CustomImageTileWidget(
          maxImageCount: metaInfo?.noOfImagesToCapture ?? 0,
          selectedImages: homeCubit.storedData[metaInfo?.label ?? ""] ?? [],
          onSelected: (selectedImages) {
            homeCubit.storedData[metaInfo?.label ?? ""] = selectedImages;
          },
          folderName: metaInfo?.savingFolder ?? "",
        ),
        sizedBoxH4,
        if ((metaInfo?.mandatory?.toLowerCase() == 'yes') &&
            homeCubit.validationFailed &&
            (homeCubit.storedData[metaInfo?.label ?? ""] == null ||
                homeCubit.storedData[metaInfo?.label ?? ""].isEmpty))
          const ValidationErrorWidget(),
        sizedBoxH12,
      ],
    );
  }
}
