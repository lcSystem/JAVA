import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../data/credits_repository.dart';
import '../../domain/models/credit_models.dart';
import '../widgets/amortization_table.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../configuracion/providers/config_provider.dart';
import '../providers/credit_request_provider.dart';

class SimulatorScreen extends ConsumerStatefulWidget {
  const SimulatorScreen({super.key});

  @override
  ConsumerState<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends ConsumerState<SimulatorScreen> {
  CreditType? _selectedType;
  double _amount = 0;
  int _term = 0;
  List<AmortizationInstallment> _schedule = [];
  bool _isSubmitting = false;
  final _currencyFormat = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    // Initialize will happen when data is loaded
  }

  void _calculateSchedule() {
    if (_selectedType == null || _amount <= 0 || _term <= 0) {
      setState(() => _schedule = []);
      return;
    }

    final principal = _amount;
    final annualRate = _selectedType!.interestRate / 100;
    final monthlyRate = annualRate / 12;
    final n = _term;

    // Payment = P * [r(1+r)^n] / [(1+r)^n - 1]
    final monthlyPayment = principal * (monthlyRate * pow(1 + monthlyRate, n)) / (pow(1 + monthlyRate, n) - 1);

    double remaining = principal;
    final List<AmortizationInstallment> newSchedule = [];
    DateTime currentDate = DateTime.now();

    for (int i = 1; i <= n; i++) {
      final interest = remaining * monthlyRate;
      double principalPayment = monthlyPayment - interest;

      if (i == n) {
        principalPayment = remaining;
      }

      remaining -= principalPayment;
      currentDate = DateTime(currentDate.year, currentDate.month + 1, currentDate.day);

      newSchedule.add(AmortizationInstallment(
        number: i,
        dueDate: currentDate,
        principal: principalPayment,
        interest: interest,
        total: principalPayment + interest,
        balance: max(0, remaining),
      ));
    }

    setState(() => _schedule = newSchedule);
  }

  Future<void> _submitRequest() async {
    final customer = ref.read(authStateProvider).customer;
    final requestState = ref.read(creditRequestProvider);
    
    if (customer == null || _selectedType == null) return;

    if (requestState.debtorInfo == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Información Incompleta', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          content: const Text('Para solicitar un crédito, primero debe completar su información personal, laboral y referencias.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/creditos/info');
              },
              child: const Text('Completar Información'),
            ),
          ],
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ref.read(creditsRepositoryProvider).submitRequest(
            applicantUserId: customer.id,
            creditTypeId: _selectedType!.id,
            amount: _amount,
            termMonths: _term,
            purpose: 'Simulación y solicitud desde app móvil',
            debtorInfo: requestState.debtorInfo!,
            references: requestState.references,
            coDebtors: requestState.coDebtors,
            previousCredits: requestState.previousCredits,
          );
      if (mounted) {
        // Reset the form state
        ref.read(creditRequestProvider.notifier).reset();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Solicitud de crédito enviada exitosamente!'), backgroundColor: Colors.green),
        );
        context.go('/creditos/mis-creditos');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final typesAsync = ref.watch(creditTypesProvider);
    final config = ref.watch(designConfigProvider).valueOrNull ?? const AppDesignConfig();

    return Scaffold(
      backgroundColor: config.backgroundColor,
      appBar: AppBar(
        title: const Text('Simulador de Crédito'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
        ),
      ),
      body: typesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (types) {
          if (_selectedType == null && types.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _selectedType = types.first;
                _amount = _selectedType!.minAmount;
                _term = _selectedType!.minTermMonths;
                _calculateSchedule();
              });
            });
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildFormCard(types, config),
                if (_schedule.isNotEmpty) ...[
                  _buildSummaryCard(config),
                  _buildAmortizationCard(config),
                  const SizedBox(height: 32),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormCard(List<CreditType> types, AppDesignConfig config) {
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
          Text('Configura tu Crédito',
              style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: config.textPrimaryColor)),
          const SizedBox(height: 24),
          
          Text('Tipo de Producto', style: _labelStyle),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: _selectedType?.id,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
            items: types.map((t) => DropdownMenuItem(value: t.id, child: Text(t.name))).toList(),
            onChanged: (v) {
              final t = types.firstWhere((x) => x.id == v);
              setState(() {
                _selectedType = t;
                _amount = t.minAmount;
                _term = t.minTermMonths;
                _calculateSchedule();
              });
            },
          ),
          
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Monto', style: _labelStyle),
              Text(_currencyFormat.format(_amount),
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: config.primaryColor, fontSize: 18)),
            ],
          ),
          Slider(
            value: _amount,
            min: _selectedType?.minAmount ?? 0,
            max: _selectedType?.maxAmount ?? 1000000,
            divisions: max(1, ((_selectedType?.maxAmount ?? 1000000) - (_selectedType?.minAmount ?? 0)) ~/ 100000),
            activeColor: config.primaryColor,
            onChanged: (v) {
              setState(() {
                _amount = v;
                _calculateSchedule();
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Min: ${_currencyFormat.format(_selectedType?.minAmount ?? 0)}', style: _hintStyle),
              Text('Max: ${_currencyFormat.format(_selectedType?.maxAmount ?? 0)}', style: _hintStyle),
            ],
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Plazo', style: _labelStyle),
              Text('$_term meses',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: config.primaryColor, fontSize: 18)),
            ],
          ),
          Slider(
            value: _term.toDouble(),
            min: (_selectedType?.minTermMonths ?? 1).toDouble(),
            max: (_selectedType?.maxTermMonths ?? 60).toDouble(),
            divisions: (_selectedType?.maxTermMonths ?? 60) - (_selectedType?.minTermMonths ?? 1),
            activeColor: config.primaryColor,
            onChanged: (v) {
              setState(() {
                _term = v.toInt();
                _calculateSchedule();
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Min: ${_selectedType?.minTermMonths}m', style: _hintStyle),
              Text('Max: ${_selectedType?.maxTermMonths}m', style: _hintStyle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(AppDesignConfig config) {
    final monthlyPayment = _schedule.isNotEmpty ? _schedule.first.total : 0.0;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [config.gradientStart, config.gradientEnd]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: config.primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Cuota Mensual Est.', style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text(_currencyFormat.format(monthlyPayment),
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: config.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isSubmitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Solicitar Crédito Ahora', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmortizationCard(AppDesignConfig config) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tabla de Amortización Proyectada',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: config.textPrimaryColor)),
          const SizedBox(height: 16),
          AmortizationTable(schedule: _schedule),
        ],
      ),
    );
  }

  TextStyle get _labelStyle => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]);
  TextStyle get _hintStyle => GoogleFonts.inter(fontSize: 10, color: Colors.grey[400], fontWeight: FontWeight.bold);
}
