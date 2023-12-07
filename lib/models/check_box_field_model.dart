class CheckboxField {
  String label;
  List<String> options;
  List<String> selectedOptions;

  CheckboxField({
    required this.label,
    required this.options,
    this.selectedOptions = const [],
  });
}
