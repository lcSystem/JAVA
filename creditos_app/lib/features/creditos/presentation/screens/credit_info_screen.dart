import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/credit_request_provider.dart';
import '../../domain/models/credit_models.dart';
import '../../../configuracion/providers/config_provider.dart';

class CreditInfoScreen extends ConsumerStatefulWidget {
  const CreditInfoScreen({super.key});

  @override
  ConsumerState<CreditInfoScreen> createState() => _CreditInfoScreenState();
}

class _CreditInfoScreenState extends ConsumerState<CreditInfoScreen> {
  int _currentStep = 1;
  final _formKey = GlobalKey<FormState>();

  // Step 1 Controllers
  final _docTypeController = TextEditingController(text: 'CC');
  final _docNumberController = TextEditingController();
  final _expeditionPlaceController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _streetController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _apartmentController = TextEditingController();

  // Step 2 Controllers
  bool _isEmployed = false;
  final _companyNameController = TextEditingController();
  final _positionController = TextEditingController();
  final _employmentYearsController = TextEditingController();
  final _workPhoneController = TextEditingController();
  final _corporateEmailController = TextEditingController();
  final _contractTypeController = TextEditingController();
  final _workAddressController = TextEditingController();

  // Step 3: Credit History
  List<PreviousCredit> _previousCredits = [];

  // Step 4: References & Co-debtors
  List<Reference> _references = [
    Reference(type: 'PERSONAL'),
    Reference(type: 'FAMILY'),
  ];
  List<CoDebtor> _coDebtors = [];

  @override
  void dispose() {
    _docNumberController.dispose();
    _expeditionPlaceController.dispose();
    _birthDateController.dispose();
    _streetController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _apartmentController.dispose();
    _companyNameController.dispose();
    _positionController.dispose();
    _employmentYearsController.dispose();
    _workPhoneController.dispose();
    _corporateEmailController.dispose();
    _contractTypeController.dispose();
    _workAddressController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      _finish();
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  void _finish() {
    // Save all to provider
    final debtorInfo = DebtorInfo(
      documentType: _docTypeController.text,
      documentNumber: _docNumberController.text,
      documentExpeditionPlace: _expeditionPlaceController.text,
      birthDate: _birthDateController.text,
      street: _streetController.text,
      neighborhood: _neighborhoodController.text,
      city: _cityController.text,
      apartment: _apartmentController.text,
      isEmployed: _isEmployed,
      companyName: _isEmployed ? _companyNameController.text : null,
      position: _isEmployed ? _positionController.text : null,
      employmentYears: _isEmployed ? int.tryParse(_employmentYearsController.text) : null,
      workPhone: _isEmployed ? _workPhoneController.text : null,
      corporateEmail: _isEmployed ? _corporateEmailController.text : null,
      contractType: _isEmployed ? _contractTypeController.text : null,
      workAddress: _isEmployed ? _workAddressController.text : null,
    );

    ref.read(creditRequestProvider.notifier).updateDebtorInfo(debtorInfo);
    ref.read(creditRequestProvider.notifier).setReferences(_references);
    ref.read(creditRequestProvider.notifier).setPreviousCredits(_previousCredits);
    ref.read(creditRequestProvider.notifier).setCoDebtors(_coDebtors);

    // Redirect to simulator
    context.push('/creditos/simulador');
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(designConfigProvider).valueOrNull ?? const AppDesignConfig();
    
    return Scaffold(
      backgroundColor: config.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Información Solicitante',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: config.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _prevStep,
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(config),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildCurrentStep(config),
            ),
          ),
          _buildBottomNav(config),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(AppDesignConfig config) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [config.gradientStart, config.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: config.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepNode(1, 'Personal', _currentStep >= 1, config),
              _buildStepConnector(_currentStep > 1, config),
              _buildStepNode(2, 'Laboral', _currentStep >= 2, config),
              _buildStepConnector(_currentStep > 2, config),
              _buildStepNode(3, 'Historial', _currentStep >= 3, config),
              _buildStepConnector(_currentStep > 3, config),
              _buildStepNode(4, 'Referencias', _currentStep >= 4, config),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _currentStep / 4,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepNode(int step, String label, bool isActive, AppDesignConfig config) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] : null,
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                color: isActive ? config.primaryColor : Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? Colors.white : Colors.white60,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(bool isActive, AppDesignConfig config) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(left: 4, right: 4, bottom: 18),
        color: isActive ? Colors.white : Colors.white.withOpacity(0.2),
      ),
    );
  }

  Widget _buildCurrentStep(AppDesignConfig config) {
    switch (_currentStep) {
      case 1:
        return _buildStep1(config);
      case 2:
        return _buildStep2(config);
      case 3:
        return _buildStep3(config);
      case 4:
        return _buildStep4(config);
      default:
        return const Center(child: Text('Paso no definido'));
    }
  }

  Widget _buildStep1(AppDesignConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.badge_outlined, 'Identificación y Residencia', config),
        const SizedBox(height: 20),
        _buildCard(
          child: Column(
            children: [
              _buildDropdownField('Tipo de Documento', _docTypeController, [
                const DropdownMenuItem(value: 'CC', child: Text('Cédula de Ciudadanía')),
                const DropdownMenuItem(value: 'CE', child: Text('Cédula de Extranjería')),
                const DropdownMenuItem(value: 'PA', child: Text('Pasaporte')),
              ]),
              const SizedBox(height: 16),
              _buildTextField('Número de Documento', _docNumberController, icon: Icons.numbers),
              const SizedBox(height: 16),
              _buildTextField('Lugar de Expedición', _expeditionPlaceController, icon: Icons.location_city),
              const SizedBox(height: 16),
              _buildTextField('Fecha de Nacimiento', _birthDateController, icon: Icons.calendar_today, isDate: true),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildSectionHeader(Icons.map_outlined, 'Ubicación', config),
        const SizedBox(height: 20),
        _buildCard(
          child: Column(
            children: [
              _buildTextField('Dirección (Calle/Carrera)', _streetController, icon: Icons.home_outlined),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextField('Barrio', _neighborhoodController)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextField('Ciudad', _cityController)),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField('Apto / Interior (Opcional)', _apartmentController),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep2(AppDesignConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader(Icons.work_outline, 'Datos Laborales', config),
            Switch(
              value: _isEmployed,
              onChanged: (val) => setState(() => _isEmployed = val),
              activeColor: config.primaryColor,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          _isEmployed ? 'Trabajador Activo' : 'Independiente / Otros',
          style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 20),
        if (_isEmployed)
          _buildCard(
            child: Column(
              children: [
                _buildTextField('Nombre de la Empresa', _companyNameController, icon: Icons.business),
                const SizedBox(height: 16),
                _buildTextField('Cargo o Posición', _positionController, icon: Icons.work_outline),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Antigüedad (años)', _employmentYearsController, keyboardType: TextInputType.number)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('Teléfono Empresa', _workPhoneController, keyboardType: TextInputType.phone)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField('Correo Corporativo', _corporateEmailController, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildTextField('Tipo de Contrato', _contractTypeController),
                const SizedBox(height: 16),
                _buildTextField('Dirección de la Empresa', _workAddressController),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: const Center(
              child: Text(
                'La información de ingresos se capturará en el siguiente paso.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStep3(AppDesignConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.history, 'Historial Crediticio', config),
        const SizedBox(height: 12),
        Text(
          'Agregue sus créditos actuales o pasados.',
          style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(height: 20),
        ..._previousCredits.asMap().entries.map((entry) {
          int idx = entry.key;
          PreviousCredit cred = entry.value;
          return _buildDynamicCard(
            title: 'Crédito #${idx + 1}',
            onDelete: () => setState(() => _previousCredits.removeAt(idx)),
            child: Column(
              children: [
                _buildTextField('Entidad Bancaria', null, 
                  initialValue: cred.bankName,
                  onChanged: (v) => cred.bankName = v,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField('Monto', null, 
                        initialValue: cred.amount.toString(),
                        onChanged: (v) => cred.amount = double.tryParse(v) ?? 0,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField('Cuota Mensual', null, 
                        initialValue: cred.monthlyInstallment.toString(),
                        onChanged: (v) => cred.monthlyInstallment = double.tryParse(v) ?? 0,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 12),
        _buildAddButton('Añadir crédito previo', () {
          setState(() => _previousCredits.add(PreviousCredit()));
        }, config),
      ],
    );
  }

  Widget _buildStep4(AppDesignConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(Icons.group_outlined, 'Referencias', config),
        const SizedBox(height: 20),
        ..._references.asMap().entries.map((entry) {
          int idx = entry.key;
          Reference ref = entry.value;
          return _buildDynamicCard(
            title: ref.type == 'PERSONAL' ? 'Referencia Personal' : 'Referencia Familiar',
            onDelete: () => setState(() => _references.removeAt(idx)),
            child: Column(
              children: [
                _buildTextField('Nombre Completo', null, 
                  initialValue: ref.fullName,
                  onChanged: (v) => ref.fullName = v,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Teléfono', null, initialValue: ref.phone, onChanged: (v) => ref.phone = v)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('Relación', null, initialValue: ref.relationship, onChanged: (v) => ref.relationship = v)),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        _buildAddButton('Añadir Referencia', () {
          setState(() => _references.add(Reference()));
        }, config),
        const SizedBox(height: 32),
        _buildSectionHeader(Icons.person_add_alt_1_outlined, 'Codeudores', config),
        const SizedBox(height: 12),
        const Text('Al menos un codeudor es obligatorio.', style: TextStyle(fontSize: 12, color: Colors.redAccent)),
        const SizedBox(height: 20),
        ..._coDebtors.asMap().entries.map((entry) {
          int idx = entry.key;
          CoDebtor co = entry.value;
          return _buildDynamicCard(
            title: 'Codeudor #${idx + 1}',
            onDelete: () => setState(() => _coDebtors.removeAt(idx)),
            child: Column(
              children: [
                _buildTextField('Nombre Completo', null, initialValue: co.fullName, onChanged: (v) => co.fullName = v),
                const SizedBox(height: 12),
                _buildTextField('Documento / ID', null, initialValue: co.documentId, onChanged: (v) => co.documentId = v),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Salario', null, initialValue: co.monthlyIncome.toString(), onChanged: (v) => co.monthlyIncome = double.tryParse(v) ?? 0, keyboardType: TextInputType.number)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('Egresos', null, initialValue: co.monthlyExpenses.toString(), onChanged: (v) => co.monthlyExpenses = double.tryParse(v) ?? 0, keyboardType: TextInputType.number)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Empresa', null, initialValue: co.companyName, onChanged: (v) => co.companyName = v)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildTextField('Antigüedad', null, initialValue: co.employmentYears.toString(), onChanged: (v) => co.employmentYears = int.tryParse(v) ?? 0, keyboardType: TextInputType.number)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField('Dirección Residencia', null, initialValue: co.address, onChanged: (v) => co.address = v),
              ],
            ),
          );
        }).toList(),
        _buildAddButton('Añadir Codeudor', () {
          setState(() => _coDebtors.add(CoDebtor()));
        }, config, isPrimary: true),
      ],
    );
  }

  // --- UI Helpers ---

  Widget _buildSectionHeader(IconData icon, String title, AppDesignConfig config) {
    return Row(
      children: [
        Icon(icon, color: config.primaryColor, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: child,
    );
  }

  Widget _buildDynamicCard({required String title, required Widget child, required VoidCallback onDelete}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14)),
              IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20)),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController? controller, {
    String? initialValue,
    IconData? icon, 
    bool isDate = false, 
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      readOnly: isDate,
      onTap: isDate ? () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (date != null && controller != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(date);
        }
      } : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[200]!)),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(fontSize: 13),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildDropdownField(String label, TextEditingController controller, List<DropdownMenuItem<String>> items) {
    return DropdownButtonFormField<String>(
      value: controller.text,
      items: items,
      onChanged: (v) {
        if (v != null) controller.text = v;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[300]!)),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: const TextStyle(fontSize: 13),
      ),
      style: const TextStyle(fontSize: 14, color: Colors.black87),
    );
  }

  Widget _buildAddButton(String label, VoidCallback onTap, AppDesignConfig config, {bool isPrimary = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isPrimary ? config.primaryColor.withOpacity(0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isPrimary ? config.primaryColor : Colors.grey[300]!, style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: isPrimary ? config.primaryColor : Colors.grey[600], size: 20),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: isPrimary ? config.primaryColor : Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(AppDesignConfig config) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 1)
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: _prevStep,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Anterior', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: config.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_currentStep == 4 ? 'Simular Crédito' : 'Siguiente Paso', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
