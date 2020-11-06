extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

double getSizeFromWidth(width) {
  const double _sizeBasis = 24.0;
  const double _sizeStep = 8.0;
  if (width > 1200) return _sizeStep * 3 + _sizeBasis;
  if (width > 900) return _sizeStep * 2 + _sizeBasis;
  if (width > 600) return _sizeStep + _sizeBasis;
  return _sizeBasis;
}

String getStringDate(DateTime date) => '${date.day}.${date.month}.${date.year}';
