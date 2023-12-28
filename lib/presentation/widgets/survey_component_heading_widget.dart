import 'package:flutter/material.dart';
import 'package:polaris_assignment/data/models/survey_form_model.dart';

class SurveyComponentHeadingWidget extends StatelessWidget {
  final MetaInfo? metaInfo;
  const SurveyComponentHeadingWidget({super.key, required this.metaInfo});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: metaInfo?.label ?? "",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            if (metaInfo?.mandatory?.toLowerCase() == "yes")
              const TextSpan(
                text: ' *',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
          ],
        ),
      ),
    );
  }
}
