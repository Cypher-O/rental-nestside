import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _fmt = NumberFormat('#,##0', 'en_NG');

  /// Returns e.g. ₦3,000,000
  static String format(num amount) => '₦${_fmt.format(amount)}';

  /// Returns e.g. ₦3,000,000/night
  static String formatPerNight(num amount) => '${format(amount)}/night';
}
