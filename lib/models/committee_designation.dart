enum CommitteeDesignation {
  president('president', 1),
  vicePresident('vice president', 2),
  secretary('secretary', 3),
  jointSecretary('joint secretary', 4),
  treasurer('treasurer', 5),
  officeBearer('office bearer', 6),
  none('', 7);

  const CommitteeDesignation(this.value, this.order);

  final String value;
  final int order;

  int compareTo(CommitteeDesignation other) => order.compareTo(other.order);

  static CommitteeDesignation byValue(String value) => CommitteeDesignation.values.singleWhere(
        (element) => element.value == value.toLowerCase(),
        orElse: () => CommitteeDesignation.none,
      );

  @override
  String toString() => value;
}
