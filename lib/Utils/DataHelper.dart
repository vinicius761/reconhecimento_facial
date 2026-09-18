import 'package:intl/intl.dart';

class DateHelper {
  // Retorna apenas a data (ex: "18/09/2026")
  static String formatarData(DateTime data) {
    return DateFormat('dd/MM/yyyy').format(data);
  }

  // Retorna apenas a hora (ex: "08:30")
  static String formatarHora(DateTime data) {
    return DateFormat('HH:mm').format(data);
  }

  // Retorna data e hora completas (ex: "18/09/2026 às 08:30")
  static String formatarDataEHora(DateTime data) {
    return DateFormat("dd/MM/yyyy 'às' HH:mm").format(data);
  }
}
