extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

double getSizeFromWidth(width) {
  if (width > 1000) return 40.0;
  if (width > 800) return 32.0;
  return 24.0;
}

String getStringDate(DateTime date) => '${date.day}.${date.month}.${date.year}';
