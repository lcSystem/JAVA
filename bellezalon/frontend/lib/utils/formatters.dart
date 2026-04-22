import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(dynamic amount) {
  if (amount == null) return '\$0.00';
  double parsed = double.tryParse(amount.toString()) ?? 0;
  String fixed = parsed.toStringAsFixed(2);
  final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String formatted = fixed.replaceAllMapped(reg, (Match match) => '${match[1]},');
  return '\$$formatted';
}

String formatTime(dynamic time, String format) {
  if (time == null) return '';
  String timeStr = time.toString();
  if (timeStr.length > 5) timeStr = timeStr.substring(0, 5);
  
  try {
    final parts = timeStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final dt = DateTime(2000, 1, 1, hour, minute);
    
    if (format == '12h') {
      return DateFormat('hh:mm a').format(dt);
    } else {
      return DateFormat('HH:mm').format(dt);
    }
  } catch (e) {
    return timeStr;
  }
}

String formatDateTime(DateTime? dt, String format) {
  if (dt == null) return '';
  if (format == '12h') {
    return DateFormat('dd MMM, hh:mm a').format(dt);
  } else {
    return DateFormat('dd MMM, HH:mm').format(dt);
  }
}
