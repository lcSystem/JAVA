import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/models/login_response.dart';
import '../../../configuracion/providers/config_provider.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

/// Client Profile Screen — view and edit (but never delete) profile data.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _workPhoneController = TextEditingController();
  final _workEmailController = TextEditingController();
  final _salaryController = TextEditingController();
  DateTime? _selectedBirthDate;
  bool _isEditing = false;
  bool _isSaving = false;
  bool _isLoading = true;

  // Temporary lists for local additions/edits
  List<CustomerAddress> _localAddresses = [];
  List<CustomerContact> _localContacts = [];

  @override
  void initState() {
    super.initState();
    _loadProfileFromApi();
  }

  /// Fetch fresh profile data from the backend API, including addresses & contacts.
  Future<void> _loadProfileFromApi() async {
    setState(() => _isLoading = true);
    try {
      final api = ApiClient();
      debugPrint('PERFIL: Llamando GET ${ApiEndpoints.profile}...');
      final response = await api.dio.get(ApiEndpoints.profile);
      debugPrint('PERFIL: Status=${response.statusCode}');
      debugPrint('PERFIL: Data=${response.data}');
      if (response.data != null) {
        final customer = CustomerProfile.fromJson(response.data);
        debugPrint('PERFIL: addresses=${customer.addresses.length}, contacts=${customer.contacts.length}');
        // Update the global auth state too
        ref.read(authProvider).updateCustomer(customer);
          setState(() {
            _nameController.text = customer.name;
            _emailController.text = customer.email ?? '';
            _phoneController.text = customer.phone ?? '';
            _selectedBirthDate = customer.birthDate;
            _birthDateController.text = customer.birthDate != null 
                ? '${customer.birthDate!.day}/${customer.birthDate!.month}/${customer.birthDate!.year}' 
                : '';
            _companyController.text = customer.companyName ?? '';
            _positionController.text = customer.position ?? '';
            _workPhoneController.text = customer.workPhone ?? '';
            _workEmailController.text = customer.corporateEmail ?? '';
            _salaryController.text = customer.salary?.toString() ?? '';
            _localAddresses = List.from(customer.addresses);
            _localContacts = List.from(customer.contacts);
          });
      }
    } catch (e) {
      debugPrint('PERFIL: ERROR cargando perfil desde API: $e');
      // Fallback: use cached data if API fails
      final customer = ref.read(authStateProvider).customer;
      if (customer != null && mounted) {
        debugPrint('PERFIL: Usando datos cacheados (addresses=${customer.addresses.length}, contacts=${customer.contacts.length})');
        setState(() {
          _nameController.text = customer.name;
          _emailController.text = customer.email ?? '';
          _phoneController.text = customer.phone ?? '';
          _selectedBirthDate = customer.birthDate;
          _birthDateController.text = customer.birthDate != null 
              ? '${customer.birthDate!.day}/${customer.birthDate!.month}/${customer.birthDate!.year}' 
              : '';
          _companyController.text = customer.companyName ?? '';
          _positionController.text = customer.position ?? '';
          _workPhoneController.text = customer.workPhone ?? '';
          _workEmailController.text = customer.corporateEmail ?? '';
          _salaryController.text = customer.salary?.toString() ?? '';
          _localAddresses = List.from(customer.addresses);
          _localContacts = List.from(customer.contacts);
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      final api = ApiClient();
      final response = await api.dio.put(ApiEndpoints.profile, data: {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'birthDate': _selectedBirthDate != null ? '${_selectedBirthDate!.year}-${_selectedBirthDate!.month.toString().padLeft(2, '0')}-${_selectedBirthDate!.day.toString().padLeft(2, '0')}' : null,
        'companyName': _companyController.text.trim(),
        'position': _positionController.text.trim(),
        'workPhone': _workPhoneController.text.trim(),
        'corporateEmail': _workEmailController.text.trim(),
        'salary': double.tryParse(_salaryController.text.trim()),
        'addresses': _localAddresses.map((e) => e.toJson()).toList(),
        'contacts': _localContacts.map((e) => e.toJson()).toList(),
      });
      
      // Update local auth state with new profile data
      if (response.data != null) {
        final updatedCustomer = CustomerProfile.fromJson(response.data);
        ref.read(authProvider).updateCustomer(updatedCustomer);
      }
      
      setState(() => _isEditing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Perfil actualizado'),
            backgroundColor: Colors.green.shade400,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _companyController.dispose();
    _positionController.dispose();
    _workPhoneController.dispose();
    _workEmailController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customer = ref.watch(authStateProvider).customer;
    final config = ref.watch(designConfigProvider).valueOrNull ?? const AppDesignConfig();

    return Scaffold(
      backgroundColor: config.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Mi Perfil',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            // Avatar
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: config.primaryColor.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: config.primaryColor.withOpacity(0.1),
                child: Text(
                  customer?.name.substring(0, 1).toUpperCase() ?? 'C',
                  style: GoogleFonts.outfit(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: config.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              customer?.name ?? 'Cliente',
              style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            Text(
              'CC: ${customer?.documentNumber ?? ''}',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            // Profile fields
            _ProfileField(
              label: 'Nombre',
              controller: _nameController,
              icon: Icons.person_outline,
              enabled: _isEditing,
            ),
            _ProfileField(
              label: 'Email',
              controller: _emailController,
              icon: Icons.email_outlined,
              enabled: _isEditing,
              keyboardType: TextInputType.emailAddress,
            ),
            _ProfileField(
              label: 'Teléfono',
              controller: _phoneController,
              icon: Icons.phone_outlined,
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
            ),
            
            // Editable Birth Date
            GestureDetector(
              onTap: _isEditing ? () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedBirthDate ?? DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _selectedBirthDate = date;
                    _birthDateController.text = '${date.day}/${date.month}/${date.year}';
                  });
                }
              } : null,
              child: AbsorbPointer(
                child: _ProfileField(
                  label: 'Fecha de Nacimiento',
                  controller: _birthDateController,
                  icon: Icons.calendar_today_outlined,
                  enabled: _isEditing,
                ),
              ),
            ),

            // Non-editable fields
            _ReadOnlyField(label: 'Cédula', value: customer?.documentNumber ?? ''),
            _ReadOnlyField(label: 'Tipo de Cliente', value: customer?.type == 'INDIVIDUAL' ? 'Persona Natural' : 'Persona Jurídica'),
            
            const SizedBox(height: 24),
            _buildSectionHeader(context, config, 'Información Laboral', Icons.work_outline, () {}),
            const SizedBox(height: 12),
            _ProfileField(
              label: 'Empresa',
              controller: _companyController,
              icon: Icons.business_outlined,
              enabled: _isEditing,
            ),
            _ProfileField(
              label: 'Cargo',
              controller: _positionController,
              icon: Icons.badge_outlined,
              enabled: _isEditing,
            ),
            _ProfileField(
              label: 'Teléfono de Trabajo',
              controller: _workPhoneController,
              icon: Icons.phone_android_outlined,
              enabled: _isEditing,
              keyboardType: TextInputType.phone,
            ),
            _ProfileField(
              label: 'Email Corporativo',
              controller: _workEmailController,
              icon: Icons.email_outlined,
              enabled: _isEditing,
              keyboardType: TextInputType.emailAddress,
            ),
            _ProfileField(
              label: 'Salario / Ingresos',
              controller: _salaryController,
              icon: Icons.attach_money_outlined,
              enabled: _isEditing,
              keyboardType: TextInputType.number,
            ),
            
            _ReadOnlyField(label: 'Estado de Cuenta', value: customer?.status ?? 'ACTIVO'),

            const SizedBox(height: 24),
            _buildSectionHeader(context, config, 'Direcciones', Icons.map_outlined, () => _showAddressDialog(context, config)),
            const SizedBox(height: 12),
            if (_localAddresses.isEmpty)
              _buildEmptySection('No hay direcciones registradas')
            else
              ..._localAddresses.map((addr) => _buildAddressCard(context, config, addr)),

            const SizedBox(height: 24),
            _buildSectionHeader(context, config, 'Contactos', Icons.contact_mail_outlined, () => _showContactDialog(context, config)),
            const SizedBox(height: 12),
            if (_localContacts.isEmpty)
              _buildEmptySection('No hay contactos registrados')
            else
              ..._localContacts.map((contact) => _buildContactCard(context, config, contact)),

            if (_isEditing) ...[
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _loadProfileFromApi();
                        setState(() => _isEditing = false);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: config.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Guardar'),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, AppDesignConfig config, String title, IconData icon, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: config.primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: config.textPrimaryColor,
              ),
            ),
          ],
        ),
        if (_isEditing)
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Agregar'),
            style: TextButton.styleFrom(
              foregroundColor: config.primaryColor,
              textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptySection(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Center(
        child: Text(
          message,
          style: GoogleFonts.inter(color: Colors.grey, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, AppDesignConfig config, CustomerAddress addr) {
    return GestureDetector(
      onTap: _isEditing ? () => _showAddressDialog(context, config, address: addr) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: config.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.location_on_outlined, color: config.primaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        addr.type.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: config.primaryColor,
                          letterSpacing: 1,
                        ),
                      ),
                      if (_isEditing)
                        Icon(Icons.edit_outlined, size: 14, color: Colors.grey.shade400),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    addr.street,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: config.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${addr.city}, ${addr.state ?? ''} ${addr.country}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: config.textSecondaryColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, AppDesignConfig config, CustomerContact contact) {
    return GestureDetector(
      onTap: _isEditing ? () => _showContactDialog(context, config, contact: contact) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: config.secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.contact_phone_outlined, color: config.secondaryColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (contact.position ?? 'Contacto').toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: config.secondaryColor,
                          letterSpacing: 1,
                        ),
                      ),
                      if (contact.birthDate != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            'Nac: ${contact.birthDate!.day}/${contact.birthDate!.month}/${contact.birthDate!.year}',
                            style: GoogleFonts.inter(fontSize: 9, color: Colors.grey),
                          ),
                        ),
                      const Spacer(),
                      Row(
                        children: [
                          if (contact.isLegalRepresentative == true)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.amber.withOpacity(0.3)),
                              ),
                              child: const Text(
                                'REP. LEGAL',
                                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.amber),
                              ),
                            ),
                          if (_isEditing)
                            Icon(Icons.edit_outlined, size: 14, color: Colors.grey.shade400),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    contact.name,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: config.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone_outlined, size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text(contact.phone, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                      if (contact.workPhone != null && contact.workPhone!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.work_outline, size: 12, color: Colors.grey.shade400),
                        const SizedBox(width: 4),
                        Text(contact.workPhone!, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                      ],
                      const SizedBox(width: 12),
                      Icon(Icons.email_outlined, size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Expanded(child: Text(contact.email, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  if (contact.companyName != null && contact.companyName!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.business_outlined, size: 12, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Text(contact.companyName!, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddressDialog(BuildContext context, AppDesignConfig config, {CustomerAddress? address}) {
    final streetCtrl = TextEditingController(text: address?.street ?? '');
    final cityCtrl = TextEditingController(text: address?.city ?? '');
    final countryCtrl = TextEditingController(text: address?.country ?? 'Colombia');
    
    // Address types mapping
    final Map<String, String> typeOptions = {
      'Casa': 'HOME',
      'Trabajo': 'WORK',
      'Facturación': 'BILLING',
      'Envío': 'SHIPPING',
    };
    
    // Find initial selected mapped value or default to HOME
    String selectedType = 'HOME';
    if (address != null && address.type.isNotEmpty) {
      if (typeOptions.values.contains(address.type.toUpperCase())) {
        selectedType = address.type.toUpperCase();
      } else {
        // Fallback for an invalid existing type, default to HOME
        selectedType = 'HOME';
      }
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(address == null ? 'Nueva Dirección' : 'Editar Dirección', style: GoogleFonts.outfit()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(controller: streetCtrl, decoration: const InputDecoration(labelText: 'Calle / Dirección')),
                TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: 'Ciudad')),
                TextField(controller: countryCtrl, decoration: const InputDecoration(labelText: 'País')),
                const SizedBox(height: 16),
                const Text('Tipo:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                DropdownButton<String>(
                  value: selectedType,
                  isExpanded: true,
                  items: typeOptions.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.value,
                      child: Text(entry.key),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedType = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: config.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            onPressed: () {
              final newAddr = CustomerAddress(
                id: address?.id,
                street: streetCtrl.text.trim(),
                city: cityCtrl.text.trim(),
                country: countryCtrl.text.trim(),
                type: selectedType,
              );
              setState(() {
                if (address == null) {
                  _localAddresses.add(newAddr);
                } else {
                  final idx = _localAddresses.indexOf(address);
                  _localAddresses[idx] = newAddr;
                }
              });
              Navigator.pop(context);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    ),
  );
}

  void _showContactDialog(BuildContext context, AppDesignConfig config, {CustomerContact? contact}) {
    final nameCtrl = TextEditingController(text: contact?.name ?? '');
    final phoneCtrl = TextEditingController(text: contact?.phone ?? '');
    final emailCtrl = TextEditingController(text: contact?.email ?? '');
    final posCtrl = TextEditingController(text: contact?.position ?? '');
    final docCtrl = TextEditingController(text: contact?.documentNumber ?? '');
    final companyCtrl = TextEditingController(text: contact?.companyName ?? '');
    final workPhoneCtrl = TextEditingController(text: contact?.workPhone ?? '');
    DateTime? selectedBirthDate = contact?.birthDate;
    bool isRep = contact?.isLegalRepresentative ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(contact == null ? 'Nuevo Contacto' : 'Editar Contacto', style: GoogleFonts.outfit()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
                TextField(controller: docCtrl, decoration: const InputDecoration(labelText: 'Documento / Cédula')),
                TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Teléfono Personal', hintText: 'Ej: 3001234567')),
                TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email', hintText: 'ejemplo@correo.com')),
                TextField(controller: posCtrl, decoration: const InputDecoration(labelText: 'Relación / Cargo', hintText: 'Gerente, Esposo(a)...')),
                TextField(controller: companyCtrl, decoration: const InputDecoration(labelText: 'Empresa (Opcional)')),
                TextField(controller: workPhoneCtrl, decoration: const InputDecoration(labelText: 'Teléfono Trabajo (Opcional)')),
                const SizedBox(height: 16),
                const Text('Fecha de Nacimiento:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(selectedBirthDate == null
                      ? 'No seleccionada'
                      : '${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}'),
                  trailing: const Icon(Icons.calendar_today_outlined, size: 20),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedBirthDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setDialogState(() => selectedBirthDate = date);
                    }
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Representante Legal', style: TextStyle(fontSize: 14)),
                  value: isRep,
                  onChanged: (v) => setDialogState(() => isRep = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                final newContact = CustomerContact(
                  id: contact?.id,
                  name: nameCtrl.text.trim(),
                  phone: phoneCtrl.text.trim(),
                  email: emailCtrl.text.trim(),
                  position: posCtrl.text.trim(),
                  documentNumber: docCtrl.text.trim().isEmpty ? null : docCtrl.text.trim(),
                  birthDate: selectedBirthDate,
                  companyName: companyCtrl.text.trim().isEmpty ? null : companyCtrl.text.trim(),
                  workPhone: workPhoneCtrl.text.trim().isEmpty ? null : workPhoneCtrl.text.trim(),
                  isLegalRepresentative: isRep,
                );
                setState(() {
                  if (contact == null) {
                    _localContacts.add(newContact);
                  } else {
                    final idx = _localContacts.indexOf(contact);
                    _localContacts[idx] = newContact;
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool enabled;
  final TextInputType? keyboardType;

  const _ProfileField({
    required this.label,
    required this.controller,
    required this.icon,
    this.enabled = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(value, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
