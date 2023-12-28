import 'package:flutter/material.dart';
import 'package:polaris_assignment/core/theme/color_constants.dart';
import 'package:polaris_assignment/domain/entity/check_box_field.dart';

class CustomCheckBox extends StatefulWidget {
  final CheckboxField checkboxField;
  final Function(CheckboxField)? selectedItemsListFunction;
  const CustomCheckBox(
      {super.key, required this.checkboxField, this.selectedItemsListFunction});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  late CheckboxField selectedItemsList;

  @override
  void initState() {
    selectedItemsList = CheckboxField(
      label: widget.checkboxField.label,
      options: List<String>.from(widget.checkboxField.options),
      selectedOptions: List<String>.from(widget.checkboxField.selectedOptions),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      key: UniqueKey(),
      shrinkWrap: true,
      itemCount: widget.checkboxField.options.length,
      itemBuilder: (context, index) {
        String option = selectedItemsList.options[index];
        return Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: CheckboxListTile(
              title: Text(
                option,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              value: selectedItemsList.selectedOptions.contains(option),
              controlAffinity:
                  ListTileControlAffinity.leading, // Checkbox on the left
              contentPadding: const EdgeInsets.only(right: 20.0),
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    selectedItemsList.selectedOptions.add(option);
                  } else {
                    selectedItemsList.selectedOptions.remove(option);
                  }
                  widget.selectedItemsListFunction!(selectedItemsList);
                });
              },
              activeColor: ColorConstants.primary),
        );
      },
    );
  }
}
