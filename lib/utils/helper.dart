import 'package:intl/intl.dart';

class Helper {
  static String rupiah(int? value) {
    if (value == null) return 'Rp 0';
    return 'Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  static String queryCreateTable(
    String tableName,
    List<String> columns,
  ) {
    return 'CREATE TABLE IF NOT EXISTS $tableName (${columns.join(', ')})';
  }

  static String convertToDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(dateTime);
    return formattedDate;
  }
}