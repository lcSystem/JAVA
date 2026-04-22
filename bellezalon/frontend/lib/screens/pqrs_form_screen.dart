import 'package:flutter/material.dart';
import '../services/api_service.dart';

class PqrsFormScreen extends StatefulWidget {
  const PqrsFormScreen({super.key});

  @override
  State<PqrsFormScreen> createState() => _PqrsFormScreenState();
}

class _PqrsFormScreenState extends State<PqrsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _asuntoCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _selectedTipo = 'queja';
  bool _isLoading = false;

  final List<Map<String, String>> _tipos = [
    {'value': 'peticion', 'label': 'Petición'},
    {'value': 'queja', 'label': 'Queja'},
    {'value': 'reclamo', 'label': 'Reclamo'},
    {'value': 'sugerencia', 'label': 'Sugerencia'},
  ];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final api = ApiService();
    final res = await api.createPqrs({
      'tipo': _selectedTipo,
      'asunto': _asuntoCtrl.text,
      'descripcion': _descCtrl.text,
    });

    if (mounted) {
      setState(() => _isLoading = false);
      if (res != null && !res.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Reporte enviado correctamente'), backgroundColor: Colors.green));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error: ${res['error'] ?? 'No se pudo enviar'}'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reportar Inconveniente')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('¿Cómo podemos ayudarte?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Completa el formulario y te responderemos lo antes posible.', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _selectedTipo,
                decoration: const InputDecoration(labelText: 'Tipo de Reporte', border: OutlineInputBorder()),
                items: _tipos.map((t) => DropdownMenuItem(value: t['value'], child: Text(t['label']!))).toList(),
                onChanged: (val) => setState(() => _selectedTipo = val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _asuntoCtrl,
                decoration: const InputDecoration(labelText: 'Asunto / Título', border: OutlineInputBorder(), hintText: 'Breve descripción del problema'),
                validator: (v) => v!.isEmpty ? 'El asunto es requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Descripción detallada', border: OutlineInputBorder(), alignLabelWithHint: true),
                maxLines: 6,
                validator: (v) => v!.isEmpty ? 'La descripción es requerida' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Enviar Reporte'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
