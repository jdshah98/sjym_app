enum CommitteeType {
  main('main'),
  yuva('yuva'),
  both('both'),
  na('');

  final String value;

  const CommitteeType(this.value);

  static CommitteeType byValue(String value) =>
      CommitteeType.values.singleWhere((element) => element.value == value, orElse: () => CommitteeType.na);

  @override
  String toString() => value;
}
