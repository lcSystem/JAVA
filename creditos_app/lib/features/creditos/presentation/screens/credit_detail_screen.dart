import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../data/credits_repository.dart';
import '../../domain/models/credit_models.dart';
import '../widgets/amortization_table.dart';
import '../../../configuracion/providers/config_provider.dart';
import '../../../configuracion/domain/models/app_design_config.dart';

class CreditDetailScreen extends ConsumerStatefulWidget {
  final int requestId;
  const CreditDetailScreen({super.key, required this.requestId});

  @override
  ConsumerState<CreditDetailScreen> createState() => _CreditDetailScreenState();
}

class _CreditDetailScreenState extends ConsumerState<CreditDetailScreen> {
  final _currencyFormat = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(designConfigProvider).valueOrNull ?? const AppDesignConfig();

    return Scaffold(
      backgroundColor: config.backgroundColor,
      appBar: AppBar(
        title: Text('Detalle de Crédito #${widget.requestId}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
        ),
        actions: [
          FutureBuilder<CreditRequest>(
            future: ref.read(creditsRepositoryProvider).getCreditDetail(widget.requestId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final credit = snapshot.data!;
                final bool isEditable = credit.status != 'APPROVED' && credit.status != 'DISBURSED';
                if (isEditable) {
                  return IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: 'Editar Solicitud',
                    onPressed: () async {
                      final result = await context.push('/creditos/editar/${credit.id}', extra: credit);
                      if (result == true) {
                        setState(() {}); // Refresh detail
                      }
                    },
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: FutureBuilder<CreditRequest>(
        future: ref.read(creditsRepositoryProvider).getCreditDetail(widget.requestId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final credit = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeaderCard(credit, config),
                if (credit.debtorAdditionalInfo != null)
                  _buildPersonalInfoSection(credit.debtorAdditionalInfo!, config),
                if (credit.debtorReferences.isNotEmpty)
                  _buildReferencesSection(credit.debtorReferences, config),
                if (credit.coDebtors.isNotEmpty)
                  _buildCoDebtorsSection(credit.coDebtors, config),
                if (credit.previousCredits.isNotEmpty)
                  _buildPreviousCreditsSection(credit.previousCredits, config),
                _buildAmortizationSection(config),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalInfoSection(DebtorInfo info, AppDesignConfig config) {
    return _SectionCard(
      title: 'Información Personal',
      config: config,
      children: [
        _InfoRow('Documento:', '${info.documentType} ${info.documentNumber}'),
        _InfoRow('Expedición:', info.documentExpeditionPlace),
        _InfoRow('F. Nacimiento:', info.birthDate),
        _InfoRow('Dirección:', '${info.street} ${info.neighborhood}'),
        _InfoRow('Ciudad:', info.city),
        if (info.apartment != null && info.apartment!.isNotEmpty) _InfoRow('Apto/Casa:', info.apartment!),
        _InfoRow('¿Empleado?:', info.isEmployed ? 'Sí' : 'No'),
        if (info.companyName != null) _InfoRow('Empresa:', info.companyName!),
        if (info.position != null) _InfoRow('Cargo:', info.position!),
        if (info.employmentYears != null) _InfoRow('Años Antigüedad:', info.employmentYears.toString()),
        if (info.workPhone != null) _InfoRow('Tel. Trabajo:', info.workPhone!),
        if (info.corporateEmail != null) _InfoRow('Email Corp:', info.corporateEmail!),
        if (info.contractType != null) _InfoRow('Tipo Contrato:', info.contractType!),
        if (info.workAddress != null) _InfoRow('Dir. Trabajo:', info.workAddress!),
      ],
    );
  }

  Widget _buildReferencesSection(List<Reference> references, AppDesignConfig config) {
    return _SectionCard(
      title: 'Referencias',
      config: config,
      children: references.map((r) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(r.fullName, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${r.type} - ${r.relationship}', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
                Text(r.phone, style: GoogleFonts.inter(fontSize: 12, color: config.primaryColor)),
              ],
            ),
            if (r != references.last) const Divider(height: 16),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildCoDebtorsSection(List<CoDebtor> coDebtors, AppDesignConfig config) {
    return _SectionCard(
      title: 'Codeudores',
      config: config,
      children: coDebtors.map((c) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(c.fullName, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
            _InfoRow('CC:', c.documentId),
            _InfoRow('Celular:', c.phone),
            _InfoRow('Email:', c.email),
            _InfoRow('Dirección:', c.address),
            _InfoRow('F. Nacimiento:', c.birthDate),
            if (c.companyName.isNotEmpty) _InfoRow('Empresa:', c.companyName),
            if (c.position.isNotEmpty) _InfoRow('Cargo:', c.position),
            if (c.employmentYears > 0) _InfoRow('Antigüedad:', '${c.employmentYears} años'),
            if (c.workPhone.isNotEmpty) _InfoRow('Tel. Trabajo:', c.workPhone),
            _InfoRow('Representante Legal:', c.isLegalRepresentative ? 'Sí' : 'No'),
            _InfoRow('Ingresos:', _currencyFormat.format(c.monthlyIncome)),
            _InfoRow('Egresos:', _currencyFormat.format(c.monthlyExpenses)),
            if (c != coDebtors.last) const Divider(height: 16),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildPreviousCreditsSection(List<PreviousCredit> credits, AppDesignConfig config) {
    return _SectionCard(
      title: 'Otros Créditos',
      config: config,
      children: credits.map((c) => _InfoRow(c.bankName, _currencyFormat.format(c.amount))).toList(),
    );
  }

  Widget _SectionCard({required String title, required List<Widget> children, required AppDesignConfig config}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: config.textPrimaryColor)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildHeaderCard(CreditRequest credit, AppDesignConfig config) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(credit.creditTypeName ?? 'Crédito',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: credit.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(credit.statusDisplay,
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: credit.statusColor)),
              ),
            ],
          ),
          const Divider(height: 32),
          _InfoRow('Monto:', _currencyFormat.format(credit.amount)),
          _InfoRow('Plazo:', '${credit.termMonths} meses'),
          if (credit.monthlyPayment != null)
            _InfoRow('Cuota Mensual:', _currencyFormat.format(credit.monthlyPayment!)),
          if (credit.totalPayment != null)
            _InfoRow('Total a Pagar:', _currencyFormat.format(credit.totalPayment!)),
        ],
      ),
    );
  }

  Widget _buildAmortizationSection(AppDesignConfig config) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tabla de Amortización',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: config.textPrimaryColor)),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: ref.read(creditsRepositoryProvider).getAmortization(widget.requestId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || snapshot.data == null) {
                return const Text('No se pudo cargar la tabla de amortización');
              }

              final schedule = snapshot.data!.map((json) {
                DateTime parseDate(dynamic dateValue) {
                  if (dateValue == null) return DateTime.now();
                  if (dateValue is String) return DateTime.parse(dateValue);
                  if (dateValue is List && dateValue.length >= 3) {
                    return DateTime(dateValue[0], dateValue[1], dateValue[2]);
                  }
                  return DateTime.now();
                }

                return AmortizationInstallment(
                  number: json['installmentNumber'] ?? json['installment_number'] ?? 0,
                  dueDate: parseDate(json['dueDate'] ?? json['due_date']),
                  principal: (json['principalAmount'] ?? json['principal_amount'] ?? 0).toDouble(),
                  interest: (json['interestAmount'] ?? json['interest_amount'] ?? 0).toDouble(),
                  total: (json['totalInstallment'] ?? json['total_installment'] ?? 0).toDouble(),
                  balance: (json['remainingBalance'] ?? json['remaining_balance'] ?? 0).toDouble(),
                );
              }).toList();

              return AmortizationTable(schedule: schedule);
            },
          ),
        ],
      ),
    );
  }

  Widget _InfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 14)),
          Text(value, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
