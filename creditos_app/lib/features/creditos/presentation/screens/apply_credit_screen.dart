import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/credits_repository.dart';

/// Apply for a Credit Screen.
class ApplyCreditScreen extends ConsumerStatefulWidget {
  const ApplyCreditScreen({super.key});

  @override
  ConsumerState<ApplyCreditScreen> createState() => _ApplyCreditScreenState();
}

class _ApplyCreditScreenState extends ConsumerState<ApplyCreditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _termController = TextEditingController();
  final _purposeController = TextEditingController();
  int? _selectedTypeId;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _termController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedTypeId == null) return;

    final customer = ref.read(authProvider).customer;
    if (customer == null) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(creditsRepositoryProvider).submitRequest(
            applicantUserId: customer.id,
            creditTypeId: _selectedTypeId!,
            amount: double.parse(_amountController.text.replaceAll(RegExp(r'[^\d.]'), '')),
            termMonths: int.parse(_termController.text),
            purpose: _purposeController.text,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('¡Solicitud enviada exitosamente!'),
            backgroundColor: Colors.green.shade400,
          ),
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final typesAsync = ref.watch(creditTypesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Crédito')),
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
                  onPressed: _isLoading ? null : _submit,
                  icon: _isLoading
                      ? const SizedBox(width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.send),
                  label: Text(_isLoading ? 'Enviando...' : 'Enviar Solicitud'),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      );
}
