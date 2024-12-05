import 'package:intl/intl.dart';

extension IntExt on int? {
  String toIdr({bool withSymbol = true}) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: withSymbol ? 'Rp ' : '',
      decimalDigits: 0,
    );
    return currencyFormatter.format(this ?? 0);
  }
}