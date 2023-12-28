import 'package:flutter/material.dart';

class CustomDropDownWidget extends StatefulWidget {
  final List<String> dropDownList;
  final String initialSelected;
  final Function(String)? selectedItem;
  const CustomDropDownWidget(
      {super.key,
      required this.dropDownList,
      this.selectedItem,
      required this.initialSelected});

  @override
  State<CustomDropDownWidget> createState() => _CustomDropDownWidgetState();
}

class _CustomDropDownWidgetState extends State<CustomDropDownWidget> {
  String firstSelected = "";

  @override
  void initState() {
    firstSelected = widget.initialSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      // Initial Value
      value: firstSelected,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),

      // Down Arrow Icon
      icon: const Icon(Icons.keyboard_arrow_down),

      // Array list of items
      items: widget.dropDownList.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),
      // After selecting the desired option,it will
      // change button value to selected value
      onChanged: (value) {
        setState(() {
          firstSelected = value.toString();
          widget.selectedItem!(firstSelected);
        });
      },
    );
  }
}
