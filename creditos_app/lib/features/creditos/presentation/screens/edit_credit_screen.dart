import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/credit_models.dart';
import '../../data/credits_repository.dart';
import '../../../configuracion/providers/config_provider.dart';
import '../../../configuracion/domain/models/app_design_config.dart';

class EditCreditScreen extends ConsumerStatefulWidget {
  final int requestId;
  final CreditRequest? initialCredit;

  const EditCreditScreen({
    super.key,
    required this.requestId,
    this.initialCredit,
  });

  @override
  ConsumerState<EditCreditScreen> createState() => _EditCreditScreenState();
}

class _EditCreditScreenState extends ConsumerState<EditCreditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _termController;
  late TextEditingController _purposeController;
  int? _selectedTypeId;
  bool _isLoading = false;
  CreditRequest? _credit;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _termController = TextEditingController();
    _purposeController = TextEditingController();
    
    if (widget.initialCredit != null) {
      _credit = widget.initialCredit;
      _populateFields();
    } else {
      _loadCredit();
    }
  }

  void _populateFields() {
    if (_credit == null) return;
    _amountController.text = _credit!.amount.toStringAsFixed(0);
    _termController.text = _credit!.termMonths.toString();
    _purposeController.text = _credit!.purpose ?? '';
    _selectedTypeId = _credit!.creditTypeId;
  }

  Future<void> _loadCredit() async {
    setState(() => _isLoading = true);
    try {
      final credit = await ref.read(creditsRepositoryProvider).getCreditDetail(widget.requestId);
      if (mounted) {
        setState(() {
          _credit = credit;
          _populateFields();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error cargando crédito: $e'), backgroundColor: Colors.red),
        );
        context.pop();
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _termController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedTypeId == null || _credit == null) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(creditsRepositoryProvider).updateRequest(
            requestId: widget.requestId,
            amount: double.parse(_amountController.text.replaceAll(RegExp(r'[^\d.]'), '')),
            termMonths: int.parse(_termController.text),
            purpose: _purposeController.text,
            debtorInfo: _credit!.debtorAdditionalInfo!,
            references: _credit!.debtorReferences,
            coDebtors: _credit!.coDebtors,
            previousCredits: _credit!.previousCredits,
          );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('¡Solicitud actualizada exitosamente!'),
            backgroundColor: Colors.green.shade400,
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(designConfigProvider).valueOrNull ?? const AppDesignConfig();
    final typesAsync = ref.watch(creditTypesProvider);

    if (_isLoading && _credit == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editar Solicitud')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: config.backgroundColor,
      appBar: AppBar(
        title: Text('Editar Solicitud #${widget.requestId}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tipo de Crédito', style: _label),
              const SizedBox(height: 8),
              typesAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Error cargando tipos'),
                data: (types) => DropdownButtonFormField<int>(
                  value: _selectedTypeId,
                  decoration: _inputDeco,
                  items: types.map((t) => DropdownMenuItem(value: t.id, child: Text(t.name))).toList(),
                  onChanged: (v) => setState(() => _selectedTypeId = v),
                  validator: (v) => v == null ? 'Seleccione un tipo' : null,
                ),
              ),
              const SizedBox(height: 20),
              Text('Monto Solicitado', style: _label),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: _inputDeco.copyWith(prefixText: '\$ '),
                validator: (v) => v == null || v.isEmpty ? 'Ingrese el monto' : null,
              ),
              const SizedBox(height: 20),
              Text('Plazo (meses)', style: _label),
              const SizedBox(height: 8),
              TextFormField(
                controller: _termController,
                keyboardType: TextInputType.number,
                decoration: _inputDeco,
                validator: (v) => v == null || v.isEmpty ? 'Ingrese el plazo' : null,
              ),
              const SizedBox(height: 20),
              Text('Propósito del Crédito', style: _label),
              const SizedBox(height: 8),
              TextFormField(
                controller: _purposeController,
                maxLines: 3,
                decoration: _inputDeco.copyWith(hintText: 'Describa el uso del crédito'),
                validator: (v) => v == null || v.isEmpty ? 'Ingrese el propósito' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _save,
                  icon: _isLoading
                      ? const SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.save_outlined),
                  label: Text(_isLoading ? 'Guardando...' : 'Guardar Cambios'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: config.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get _label => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]);
  InputDecoration get _inputDeco => InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      );
}
