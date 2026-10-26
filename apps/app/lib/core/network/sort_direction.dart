/// Sort direction for query sorting in ABA ERP API requests.
enum SortDirection {
  asc('ASC'),
  desc('DESC');

  const SortDirection(this.value);
  final String value;

  static SortDirection fromString(String? value) {
    if (value == null) return SortDirection.desc;
    return value.toUpperCase().trim() == 'ASC' ? SortDirection.asc : SortDirection.desc;
  }
}
