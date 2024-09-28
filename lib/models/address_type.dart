enum AddressType {
  area('area'),
  native('native');

  final String value;

  const AddressType(this.value);

  static AddressType byValue(String value) => AddressType.values.singleWhere(
        (element) => element.value == value,
      );

  @override
  String toString() => value;
}
