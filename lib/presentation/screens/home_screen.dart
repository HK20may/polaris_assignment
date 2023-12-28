import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris_assignment/core/constants/app_assets_path.dart';
import 'package:polaris_assignment/core/theme/color_constants.dart';
import 'package:polaris_assignment/core/constants/constants.dart';
import 'package:polaris_assignment/core/theme/widgets_and_attributes.dart';
import 'package:polaris_assignment/core/isolate/background_task.dart';
import 'package:polaris_assignment/core/widgets/primary_button.dart';
import 'package:polaris_assignment/data/enums/component_type_enum.dart';
import 'package:polaris_assignment/data/models/survey_form_model.dart';
import 'package:polaris_assignment/presentation/cubit/home_cubit.dart';
import 'package:polaris_assignment/presentation/widgets/survey_capture_image_widget.dart';
import 'package:polaris_assignment/presentation/widgets/survey_check_box_widget.dart';
import 'package:polaris_assignment/presentation/widgets/survey_drop_down_widget.dart';
import 'package:polaris_assignment/presentation/widgets/survey_radio_button_widget.dart';
import 'package:polaris_assignment/presentation/widgets/survey_text_field_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeCubit _homeCubit = HomeCubit();

  @override
  void initState() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        if (_homeCubit.surveyFormData == null) {
          initData();
        }
        BackgroundTask.doWork(Constants.DATABASE_SYNC_SERVICE);
        _hideInternetStatusSnackbar(context);
      } else {
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
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: ColorConstants.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
          ),
          // leading: Image.asset("assets/images/polaris_icon.jpeg"),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  AppAssetsPath.polarisAppIcon,
                  height: 40,
                  width: 40,
                ),
              ),
              sizedBoxW20,
              const Text(
                "Polaris",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizedBoxH20,
                    Text(
                      _homeCubit.surveyFormData?.formName ?? "",
                      style: TextStyle(
                          color: Colors.teal.shade900,
                          fontSize: 28,
                          fontWeight: FontWeight.w500),
                    ),
                    sizedBoxH20,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
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

                          if (componentType ==
                              ComponentTypeEnum.editText.componentName) {
                            return SurveyTextFieldWidget(metaInfo: metaInfo);
                          } else if (componentType ==
                              ComponentTypeEnum.checkBoxes.componentName) {
                            return SurveyCheckBoxWidget(metaInfo: metaInfo);
                          } else if (componentType ==
                              ComponentTypeEnum.dropDown.componentName) {
                            return SurveyDropDownWidget(metaInfo: metaInfo);
                          } else if (componentType ==
                              ComponentTypeEnum.radioGroup.componentName) {
                            return SurveyRadioButtonWidget(metaInfo: metaInfo);
                          } else if (componentType ==
                              ComponentTypeEnum.captureImages.componentName) {
                            return SurveyCaptureImageWidget(metaInfo: metaInfo);
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                    sizedBoxH42
                  ],
                ),
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
          Text("No Internet Found",
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
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
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
