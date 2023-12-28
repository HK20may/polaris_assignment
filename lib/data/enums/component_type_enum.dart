enum ComponentTypeEnum {
  editText('EditText'),
  checkBoxes('CheckBoxes'),
  dropDown('DropDown'),
  captureImages('CaptureImages'),
  radioGroup('RadioGroup'),
  none('None');

  const ComponentTypeEnum(this.componentName);

  final String componentName;

  static ComponentTypeEnum fromComponentName(String? name) {
    return ComponentTypeEnum.values.firstWhere(
      (element) => element.componentName == name,
      orElse: () => ComponentTypeEnum.none,
    );
  }
}
