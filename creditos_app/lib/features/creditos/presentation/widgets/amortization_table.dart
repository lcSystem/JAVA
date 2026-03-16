import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AmortizationInstallment {
  final int number;
  final DateTime dueDate;
  final double principal;
  final double interest;
  final double total;
  final double balance;

  AmortizationInstallment({
    required this.number,
    required this.dueDate,
    required this.principal,
    required this.interest,
    required this.total,
    required this.balance,
  });
}

class AmortizationTable extends StatelessWidget {
  final List<AmortizationInstallment> schedule;

  const AmortizationTable({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    if (schedule.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('No hay datos de amortización disponibles'),
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        horizontalMargin: 12,
        columnSpacing: 24,
        headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
        columns: [
          DataColumn(label: Text('Cuota', style: _headerStyle)),
          DataColumn(label: Text('Fecha', style: _headerStyle)),
          DataColumn(label: Text('Capital', style: _headerStyle)),
          DataColumn(label: Text('Interés', style: _headerStyle)),
          DataColumn(label: Text('Total', style: _headerStyle)),
          DataColumn(label: Text('Saldo', style: _headerStyle)),
        ],
        rows: schedule.map((item) {
          return DataRow(cells: [
            DataCell(Text(item.number.toString(), style: _cellStyle)),
            DataCell(Text(dateFormat.format(item.dueDate), style: _cellStyle)),
            DataCell(Text(currencyFormat.format(item.principal), style: _cellStyle)),
            DataCell(Text(currencyFormat.format(item.interest), style: _cellStyle)),
            DataCell(Text(currencyFormat.format(item.total), style: _cellStyle)),
            DataCell(Text(currencyFormat.format(item.balance), style: _cellStyle.copyWith(fontWeight: FontWeight.bold))),
          ]);
        }).toList(),
      ),
    );
  }

  TextStyle get _headerStyle => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.grey[800],
      );

  TextStyle get _cellStyle => GoogleFonts.inter(
        fontSize: 12,
        color: Colors.grey[700],
      );
}
