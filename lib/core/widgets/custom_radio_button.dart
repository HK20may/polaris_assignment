import 'package:flutter/material.dart';
import 'package:polaris_assignment/core/theme/color_constants.dart';

class CustomRadioButtonWidget extends StatefulWidget {
  final List<String> radioButtonList;
  final String selectedOption;
  final Function(String)? selectedItem;
  const CustomRadioButtonWidget(
      {super.key,
      required this.radioButtonList,
      required this.selectedOption,
      this.selectedItem});

  @override
  State<CustomRadioButtonWidget> createState() =>
      _CustomRadioButtonWidgetState();
}

class _CustomRadioButtonWidgetState extends State<CustomRadioButtonWidget> {
  String selectedValue = "";

  @override
  void initState() {
    selectedValue = widget.selectedOption;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.radioButtonList
          .map(
            (String option) => Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: RadioListTile(
                value: option,
                dense: false,
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.zero,
                groupValue: selectedValue,
                activeColor: ColorConstants.primary,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                    widget.selectedItem!(selectedValue);
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(
                  option,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
