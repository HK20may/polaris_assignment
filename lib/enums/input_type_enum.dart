enum InputTypeEnum {
  integer("INTEGER"),
  text("TEXT");

  const InputTypeEnum(this.typeName);

  final String typeName;

  static InputTypeEnum fromName(String name) {
    return InputTypeEnum.values.firstWhere(
      (element) => element.typeName == name,
      orElse: () => InputTypeEnum.text,
    );
  }
}
