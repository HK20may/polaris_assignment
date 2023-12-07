import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_assignment/core/helpers/color_constants.dart';
import 'package:polaris_assignment/core/helpers/widgets_and_attributes.dart';
import 'package:polaris_assignment/core/utils/toast.dart';
import 'package:polaris_assignment/models/survey_form_model.dart';
import 'package:polaris_assignment/view/cubit/home_cubit.dart';
import 'package:polaris_assignment/view/global_widgets/primary_button.dart';
import 'package:polaris_assignment/view/ui/widgets/survey_capture_image_widget.dart';
import 'package:polaris_assignment/view/ui/widgets/survey_check_box_widget.dart';
import 'package:polaris_assignment/view/ui/widgets/survey_drop_down_widget.dart';
import 'package:polaris_assignment/view/ui/widgets/survey_radio_button_widget.dart';
import 'package:polaris_assignment/view/ui/widgets/survey_text_field_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeCubit _homeCubit = HomeCubit();
  bool showToast = false;

  @override
  void initState() {
    initData();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        if (_homeCubit.surveyFormData == null) {
          initData();
        }
        if (showToast) {
          Toast.info("Connection restored, Submit again to Proceed");
        }
        _hideInternetStatusSnackbar(context);
      } else {
        showToast = true;
        _showInternetStatusSnackbar(context);
      }
    });
    super.initState();
  }

  Future<void> initData() async {
    await _homeCubit.fetchDynamicSurveyData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _homeCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<HomeCubit, HomeState>(
          buildWhen: (previous, current) {
            if (previous != current && current is SurveyFormUploadLoading) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            if (state is SurveyFormLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                color: ColorConstants.primary,
              ));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: kToolbarHeight,
                  ),
                  Text(
                    _homeCubit.surveyFormData?.formName ?? "",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            key: UniqueKey(),
                            itemCount:
                                _homeCubit.surveyFormData?.fields?.length ?? 0,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              MetaInfo? metaInfo = _homeCubit
                                  .surveyFormData?.fields?[index].metaInfo;

                              String? componentType = _homeCubit
                                  .surveyFormData?.fields?[index].componentType;

                              if (componentType == "EditText") {
                                return SurveyTextFieldWidget(
                                    metaInfo: metaInfo);
                              } else if (componentType == "CheckBoxes") {
                                return SurveyCheckBoxWidget(metaInfo: metaInfo);
                              } else if (componentType == "DropDown") {
                                return SurveyDropDownWidget(metaInfo: metaInfo);
                              } else if (componentType == "RadioGroup") {
                                return SurveyRadioButtonWidget(
                                    metaInfo: metaInfo);
                              } else if (componentType == "CaptureImages") {
                                return SurveyCaptureImageWidget(
                                    metaInfo: metaInfo);
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                          sizedBoxH42
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: _buildButton(),
      ),
    );
  }

  void _showInternetStatusSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            color: Colors.red.shade600,
          ),
          sizedBoxW12,
          Text("You need Internet to proceed",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red.shade600)),
        ],
      ),
      backgroundColor: Colors.red.shade100,
      duration: const Duration(days: 365),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _hideInternetStatusSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  Widget _buildButton() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is SurveyFormLoading) {
          return const SizedBox.shrink();
        }
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: ColorConstants.shadowColor,
                blurRadius: 18,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: PrimaryButton(
            "Submit",
            isLoading: state is SurveyFormUploadLoading,
            onPressed: () async {
              _homeCubit.checkValidation();
              if (!_homeCubit.validationFailed) {
                await _homeCubit.postSurveyData();
              }
            },
          ),
        );
      },
    );
  }
}
