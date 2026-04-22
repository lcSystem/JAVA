import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/settings_provider.dart';
import '../services/api_service.dart';
import '../utils/offline_guard.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _businessNameController = TextEditingController();
  final _maxBookingsController = TextEditingController();
  final _maxPendingController = TextEditingController();
  final _maxServiceImagesController = TextEditingController();
  String _selectedColor = '#8C4D53';
  String _logoPath = '';
  bool _isLoading = false;

  // Email settings
  final _smtpHostController = TextEditingController();
  final _smtpPortController = TextEditingController();
  final _smtpUserController = TextEditingController();
  final _smtpPassController = TextEditingController();
  final _smtpFromAddressController = TextEditingController();
  final _smtpFromNameController = TextEditingController();
  String _smtpEncryption = 'tls';
  bool _enableEmailNotifications = false;

  // Payment settings
  bool _requireAdvancePayment = false;
  String _paymentGateway = 'epaico';
  final _epaicoPublicKeyController = TextEditingController();
  final _epaicoPrivateKeyController = TextEditingController();
  final _mpPublicKeyController = TextEditingController();
  final _mpPrivateKeyController = TextEditingController();
  final _stripePublicKeyController = TextEditingController();
  final _stripePrivateKeyController = TextEditingController();
  bool _paymentTestMode = true;
  double _advancePercentage = 100;
  
  // Tax settings
  bool _isTaxEnabled = false;
  List<Map<String, dynamic>> _taxes = [];
  String _timeFormat = '24h';

  // Schedule settings
  Map<String, dynamic> _blockedSchedules = {
    'monday': {'closed': false, 'blocks': []},
    'tuesday': {'closed': false, 'blocks': []},
    'wednesday': {'closed': false, 'blocks': []},
    'thursday': {'closed': false, 'blocks': []},
    'friday': {'closed': false, 'blocks': []},
    'saturday': {'closed': false, 'blocks': []},
    'sunday': {'closed': false, 'blocks': []},
  };

  static const List<String> _colorPalette = [
    '#8C4D53', '#C0392B', '#E74C3C', '#9B59B6', '#8E44AD',
    '#2980B9', '#3498DB', '#1ABC9C', '#16A085', '#27AE60',
    '#2ECC71', '#F39C12', '#E67E22', '#D35400', '#34495E',
    '#2C3E50', '#7F8C8D', '#95A5A6', '#E91E63', '#673AB7',
    '#3F51B5', '#00BCD4', '#009688', '#4CAF50', '#FF5722',
    '#795548', '#607D8B', '#FF4081', '#536DFE', '#00E676',
  ];

  static const List<String> _allowedImageExtensions = ['png', 'jpg', 'jpeg', 'webp', 'svg'];

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    _businessNameController.text = settings.settings['salon_name'] ?? 'Salón Belleza Pro';
    _selectedColor = settings.settings['primary_color'] ?? '#8C4D53';
    _maxBookingsController.text = settings.settings['max_appointments_per_day'] ?? '20';
    _maxPendingController.text = settings.settings['max_pending_appointments_per_client'] ?? '2';
    _maxServiceImagesController.text = settings.settings['max_service_images'] ?? '5';
    _logoPath = settings.settings['salon_logo_url'] ?? '';
    
    // Initialize tax settings
    _isTaxEnabled = settings.settings['is_tax_enabled'] == 'true';
    try {
      final taxesJson = settings.settings['business_taxes'] ?? '[]';
      _taxes = List<Map<String, dynamic>>.from(jsonDecode(taxesJson));
    } catch (e) {
      _taxes = [];
    }

    try {
      final schedulesJson = settings.settings['blocked_schedules'] ?? '{}';
      final decoded = jsonDecode(schedulesJson) as Map<String, dynamic>;
      // Merge with default to ensure all days are present
      decoded.forEach((key, value) {
        if (_blockedSchedules.containsKey(key)) {
          _blockedSchedules[key] = value;
        }
      });
    } catch (e) {
      debugPrint("Error loading schedules: $e");
    }
    _timeFormat = settings.settings['time_format'] ?? '24h';

    // Initialize email settings
    _smtpHostController.text = settings.settings['smtp_host'] ?? 'smtp.gmail.com';
    _smtpPortController.text = settings.settings['smtp_port'] ?? '587';
    _smtpUserController.text = settings.settings['smtp_user'] ?? '';
    _smtpPassController.text = settings.settings['smtp_pass'] ?? '';
    _smtpFromAddressController.text = settings.settings['mail_from_address'] ?? '';
    _smtpFromNameController.text = settings.settings['mail_from_name'] ?? 'Salón Belleza Pro';
    _smtpEncryption = settings.settings['smtp_encryption'] ?? 'tls';
    _enableEmailNotifications = settings.settings['enable_email_notifications'] == '1';

    // Initialize payment settings
    _requireAdvancePayment = settings.settings['require_advance_payment'] == 'true';
    _paymentGateway = settings.settings['payment_gateway'] ?? 'epaico';
    _epaicoPublicKeyController.text = settings.settings['epaico_public_key'] ?? '';
    _epaicoPrivateKeyController.text = ''; // Don't show existing private key for security
    _mpPublicKeyController.text = settings.settings['mercadopago_public_key'] ?? '';
    _mpPrivateKeyController.text = '';
    _stripePublicKeyController.text = settings.settings['stripe_public_key'] ?? '';
    _stripePrivateKeyController.text = '';
    _paymentTestMode = settings.settings['payment_test_mode'] != 'false'; // default true
    _advancePercentage = double.tryParse(settings.settings['advance_payment_percentage'] ?? '100') ?? 100;
  }

  Color _parseHex(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length != 6) return Colors.grey;
    return Color(int.parse('FF$hex', radix: 16));
  }

  void _pickLogo() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image == null) return;

    setState(() => _isLoading = true);
    
    final api = ApiService();
    try {
      final bytes = await image.readAsBytes();
      final result = await api.uploadLogo(bytes, image.name);
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (result['success'] == true) {
        setState(() {
          _logoPath = result['url'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Logotipo actualizado'), backgroundColor: Colors.green),
        );
        // Also update settings provider to reflect changes immediately
        await Provider.of<SettingsProvider>(context, listen: false).fetchSettings();
        if (mounted) {
          setState(() {
            _logoPath = Provider.of<SettingsProvider>(context, listen: false).salonLogo;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: ${result['error']}'), backgroundColor: Colors.red),
        );
      }
    }
    } on OfflineException catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]),
          backgroundColor: Colors.red[700],
        ));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error inesperado: $e'), backgroundColor: Colors.red));
      }
    }
  }

  void _showTaxDialog({Map<String, dynamic>? tax, int? index}) {
    final nameCtrl = TextEditingController(text: tax?['name'] ?? '');
    final rateCtrl = TextEditingController(text: tax?['rate']?.toString() ?? '');
    bool isActive = tax?['active'] ?? true;
    bool isInvisible = tax?['invisible'] ?? false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setDialogState) => AlertDialog(
        title: Text(tax == null ? 'Nuevo Impuesto' : 'Editar Impuesto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nombre (ej: IVA)'),
            ),
            TextField(
              controller: rateCtrl,
              decoration: const InputDecoration(labelText: 'Porcentaje (%)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Activo para ventas'),
              subtitle: Text(isActive ? 'Se aplicará en ventas' : 'No se aplicará'),
              value: isActive,
              onChanged: (v) => setDialogState(() => isActive = v),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              title: const Text('Es invisible'),
              subtitle: const Text('Se suma al precio del producto'),
              value: isInvisible,
              onChanged: (v) => setDialogState(() => isInvisible = v),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty || rateCtrl.text.isEmpty) return;
              final newTax = {
                'name': nameCtrl.text,
                'rate': double.tryParse(rateCtrl.text) ?? 0.0,
                'active': isActive,
                'invisible': isInvisible,
              };
              setState(() {
                if (index == null) {
                  _taxes.add(newTax);
                } else {
                  _taxes[index] = newTax;
                }
              });
              Navigator.pop(ctx);
            },
            child: const Text('Guardar'),
          ),
        ],
      )),
    );
  }

  Future<void> _saveSettings() async {
    final sp = Provider.of<SettingsProvider>(context, listen: false);
    try {
      final success = await sp.updateSettings({
      'salon_name': _businessNameController.text,
      'primary_color': _selectedColor,
      'max_appointments_per_day': _maxBookingsController.text,
      'max_pending_appointments_per_client': _maxPendingController.text,
      'max_service_images': _maxServiceImagesController.text,
      'salon_logo_url': _logoPath,
      'is_tax_enabled': _isTaxEnabled.toString(),
      'business_taxes': jsonEncode(_taxes),
      'blocked_schedules': jsonEncode(_blockedSchedules),
      'time_format': _timeFormat,
      'smtp_host': _smtpHostController.text,
      'smtp_port': _smtpPortController.text,
      'smtp_user': _smtpUserController.text,
      'smtp_pass': _smtpPassController.text,
      'smtp_encryption': _smtpEncryption,
      'mail_from_address': _smtpFromAddressController.text,
      'mail_from_name': _smtpFromNameController.text,
      'enable_email_notifications': _enableEmailNotifications ? '1' : '0',
      'require_advance_payment': _requireAdvancePayment.toString(),
      'payment_gateway': _paymentGateway,
      'epaico_public_key': _epaicoPublicKeyController.text,
      'epaico_private_key': _epaicoPrivateKeyController.text.isNotEmpty ? _epaicoPrivateKeyController.text : (sp.settings['epaico_private_key'] ?? ''),
      'mercadopago_public_key': _mpPublicKeyController.text,
      'mercadopago_private_key': _mpPrivateKeyController.text.isNotEmpty ? _mpPrivateKeyController.text : (sp.settings['mercadopago_private_key'] ?? ''),
      'stripe_public_key': _stripePublicKeyController.text,
      'stripe_private_key': _stripePrivateKeyController.text.isNotEmpty ? _stripePrivateKeyController.text : (sp.settings['stripe_private_key'] ?? ''),
      'payment_test_mode': _paymentTestMode.toString(),
      'advance_payment_percentage': _advancePercentage.toInt().toString(),
    });

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Configuración guardada exitosamente'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Error al guardar la configuración. Verifique su conexión o permisos.'), backgroundColor: Colors.red),
        );
      }
    }
    } on OfflineException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]),
          backgroundColor: Colors.red[700],
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error inesperado: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = _parseHex(_selectedColor);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kTextTabBarHeight),
          child: ColoredBox(
            color: Colors.white,
            child: SafeArea(
              child: TabBar(
                labelColor: Colors.black,
                tabs: [
                  Tab(icon: Icon(Icons.design_services), text: 'Diseño'),
                  Tab(icon: Icon(Icons.settings), text: 'Configuración'),
                  Tab(icon: Icon(Icons.payment), text: 'Pagos'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
             _buildDesignTab(primary),
             _buildConfigTab(primary),
             _buildPaymentsTab(primary),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _saveSettings,
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text('Guardar Todo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 4,
                shadowColor: primary.withOpacity(0.4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesignTab(Color primary) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionHeader(Icons.palette, 'Personalización Visual', primary),
        const SizedBox(height: 16),
        TextField(
          controller: _businessNameController,
          decoration: InputDecoration(
            labelText: 'Nombre del Negocio',
            hintText: 'Ej: Salón Belleza Pro',
            prefixIcon: const Icon(Icons.store),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Color Primario', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))],
                ),
                child: Center(child: Text('Vista previa: $_selectedColor', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _colorPalette.map((hex) {
                  final color = _parseHex(hex);
                  final isSelected = hex == _selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = hex),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: isSelected ? Colors.black : Colors.transparent, width: isSelected ? 3 : 0),
                        boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)] : null,
                      ),
                      child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Logotipo del Negocio', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              if (_logoPath.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _logoPath.startsWith('/uploads') 
                    ? CachedNetworkImage(
                        imageUrl: '${ApiService.assetsBaseUrl}$_logoPath', 
                        height: 100, 
                        fit: BoxFit.contain,
                        errorWidget: (ctx, _, __) => Container(
                          height: 100, 
                          color: Colors.grey[200], 
                          child: const Center(child: Icon(Icons.broken_image, color: Colors.grey))
                        ),
                      )
                    : Container(
                        height: 100, 
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                        child: const Center(child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey)),
                      ),
                )
              else
                Container(
                  height: 100,
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey)),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _pickLogo,
                  icon: const Icon(Icons.upload_file),
                  label: Text(_logoPath.isEmpty ? 'Seleccionar imagen' : 'Cambiar imagen'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildSectionHeader(Icons.rule, 'Reglas de Negocio', primary),
        const SizedBox(height: 16),
        TextField(
          controller: _maxBookingsController,
          decoration: InputDecoration(
            labelText: 'Citas máximas por día',
            hintText: '20',
            prefixIcon: const Icon(Icons.event_busy),
            helperText: 'Limita la cantidad de citas que se pueden agendar en un solo día',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _maxPendingController,
          decoration: InputDecoration(
            labelText: 'Citas pendientes máximas por cliente',
            hintText: '2',
            prefixIcon: const Icon(Icons.person_off),
            helperText: 'Límite de citas en estado "pendiente" para evitar saturación fraudulenta',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _maxServiceImagesController,
          decoration: InputDecoration(
            labelText: 'Imágenes máximas por servicio',
            hintText: '5',
            prefixIcon: const Icon(Icons.photo_library),
            helperText: 'Controla el límite de fotos permitidas en el catálogo de cada servicio',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildConfigTab(Color primary) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionHeader(Icons.monetization_on, 'Gestión de Impuestos', primary),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Aplicar Impuestos en Ventas', style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('Habilita el cálculo automático de impuestos'),
          value: _isTaxEnabled,
          onChanged: (val) => setState(() => _isTaxEnabled = val),
          activeColor: primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tileColor: Colors.grey[50],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.access_time, color: Colors.grey),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Formato de Hora', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Selecciona cómo se mostrarán las horas', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              DropdownButton<String>(
                value: _timeFormat,
                underline: const SizedBox(),
                onChanged: (v) {
                  if (v != null) setState(() => _timeFormat = v);
                },
                items: const [
                  DropdownMenuItem(value: '24h', child: Text('24 Horas (14:00)')),
                  DropdownMenuItem(value: '12h', child: Text('12 Horas (02:00 PM)')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Lista de Impuestos', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ElevatedButton.icon(
              onPressed: () => _showTaxDialog(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Agregar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_taxes.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 12),
                  Text('No hay impuestos configurados', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          )
        else
          ..._taxes.asMap().entries.map((entry) {
            final index = entry.key;
            final tax = entry.value;
            final bool taxActive = tax['active'] ?? true;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: taxActive ? primary.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                  child: Text('${tax['rate']}%', style: TextStyle(color: taxActive ? primary : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                title: Row(children: [
                  Text(tax['name'], style: TextStyle(fontWeight: FontWeight.bold, color: taxActive ? null : Colors.grey)),
                  const SizedBox(width: 8),
                  if (tax['invisible'] == true) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: const Text('INVISIBLE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                    const SizedBox(width: 4),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: taxActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(taxActive ? 'ACTIVO' : 'INACTIVO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: taxActive ? Colors.green : Colors.grey)),
                  ),
                ]),
                subtitle: Text(tax['invisible'] == true ? 'Se suma al precio unitario' : (taxActive ? 'Se aplica en ventas' : 'No se aplica en ventas'), style: TextStyle(color: taxActive ? null : Colors.grey)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: taxActive,
                      activeColor: primary,
                      onChanged: (v) => setState(() => _taxes[index] = {...tax, 'active': v}),
                    ),
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showTaxDialog(tax: tax, index: index)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => _taxes.removeAt(index))),
                  ],
                ),
              ),
            );
          }).toList(),
        const SizedBox(height: 32),
        _buildSectionHeader(Icons.schedule, 'Horarios y Bloqueos', primary),
        const SizedBox(height: 16),
        const Text('Configura los días que el local permanece cerrado o bloquea rangos de horas específicos.', 
          style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 16),
        ..._blockedSchedules.keys.map((day) {
          final sch = _blockedSchedules[day];
          final bool isClosed = sch['closed'] ?? false;
          final List blocks = sch['blocks'] ?? [];

          final Map<String, String> dayNames = {
            'monday': 'Lunes', 'tuesday': 'Martes', 'wednesday': 'Miércoles',
            'thursday': 'Jueves', 'friday': 'Viernes', 'saturday': 'Sábado', 'sunday': 'Domingo'
          };
          final String dayLabel = dayNames[day] ?? day.toUpperCase();

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey[200]!),
            ),
            child: ExpansionTile(
              leading: Icon(Icons.calendar_today, color: isClosed ? Colors.grey : primary, size: 20),
              title: Text(dayLabel, style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: isClosed ? Colors.grey : null,
                decoration: isClosed ? TextDecoration.lineThrough : null
              )),
              subtitle: Text(isClosed ? 'CERRADO TODO EL DÍA' : '${blocks.length} bloqueos configurados',
                style: TextStyle(fontSize: 11, color: isClosed ? Colors.red : Colors.grey)),
              children: [
                SwitchListTile(
                  title: const Text('Local Cerrado'),
                  subtitle: const Text('Ningún cliente podrá agendar este día'),
                  value: isClosed,
                  onChanged: (val) => setState(() => _blockedSchedules[day]['closed'] = val),
                  activeColor: Colors.red,
                ),
                if (!isClosed) ...[
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Bloqueos Horarios', style: TextStyle(fontWeight: FontWeight.bold)),
                        TextButton.icon(
                          onPressed: () => _addBlockDialog(day),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Agregar Bloqueo'),
                        ),
                      ],
                    ),
                  ),
                  if (blocks.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text('Sin bloqueos adicionales', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    )
                  else
                    ...blocks.asMap().entries.map((blockEntry) {
                      final blockIdx = blockEntry.key;
                      final block = blockEntry.value;
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.access_time, size: 16),
                        title: Text('${block['start']} - ${block['end']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                          onPressed: () => setState(() => (_blockedSchedules[day]['blocks'] as List).removeAt(blockIdx)),
                        ),
                      );
                    }).toList(),
                ],
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 32),
        _buildSectionHeader(Icons.email, 'Notificaciones por Correo', primary),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                title: const Text('Enviar correos automáticos', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Activa el envío de facturas y avisos de citas'),
                value: _enableEmailNotifications,
                onChanged: (val) => setState(() => _enableEmailNotifications = val),
                activeColor: primary,
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(height: 32),
              if (_enableEmailNotifications) ...[
                const Text('Configuración del Servidor (SMTP)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 16),
                _buildTextField(_smtpHostController, 'Host SMTP', Icons.dns, 'ej: smtp.gmail.com'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTextField(_smtpPortController, 'Puerto', Icons.numbers, '587', keyboardType: TextInputType.number)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _smtpEncryption,
                        decoration: InputDecoration(
                          labelText: 'Cifrado',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'tls', child: Text('TLS')),
                          DropdownMenuItem(value: 'ssl', child: Text('SSL')),
                          DropdownMenuItem(value: 'none', child: Text('Ninguno')),
                        ],
                        onChanged: (v) => setState(() => _smtpEncryption = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(_smtpUserController, 'Usuario / Correo', Icons.alternate_email, 'ej: tu-correo@gmail.com'),
                const SizedBox(height: 12),
                _buildTextField(_smtpPassController, 'Contraseña de Aplicación', Icons.password, '****', obscureText: true),
                const SizedBox(height: 20),
                const Text('Información del Remitente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 16),
                _buildTextField(_smtpFromNameController, 'Nombre del Remitente', Icons.person, 'Nombre del Salón'),
                const SizedBox(height: 12),
                _buildTextField(_smtpFromAddressController, 'Correo del Remitente', Icons.email_outlined, 'ej: no-reply@tudominio.com'),
              ],
            ],
          ),
        ),
        const SizedBox(height: 100), // Padding extra para scroll
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, String hint, {TextInputType keyboardType = TextInputType.text, bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      ),
    );
  }

  void _addBlockDialog(String day) async {
    TimeOfDay? start = const TimeOfDay(hour: 12, minute: 0);
    TimeOfDay? end = const TimeOfDay(hour: 14, minute: 0);

    final Map<String, String> dayNames = {
      'monday': 'Lunes', 'tuesday': 'Martes', 'wednesday': 'Miércoles',
      'thursday': 'Jueves', 'friday': 'Viernes', 'saturday': 'Sábado', 'sunday': 'Domingo'
    };
    final String dayLabel = dayNames[day] ?? day.toUpperCase();

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStfState) => AlertDialog(
          title: Text('Bloquear Horario - $dayLabel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Inicio'),
                trailing: Text(start!.format(context)),
                onTap: () async {
                  final t = await showTimePicker(context: context, initialTime: start!);
                  if (t != null) setStfState(() => start = t);
                },
              ),
              ListTile(
                title: const Text('Fin'),
                trailing: Text(end!.format(context)),
                onTap: () async {
                  final t = await showTimePicker(context: context, initialTime: end!);
                  if (t != null) setStfState(() => end = t);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                final startStr = '${start!.hour.toString().padLeft(2, '0')}:${start!.minute.toString().padLeft(2, '0')}';
                final endStr = '${end!.hour.toString().padLeft(2, '0')}:${end!.minute.toString().padLeft(2, '0')}';
                setState(() {
                  (_blockedSchedules[day]['blocks'] as List).add({'start': startStr, 'end': endStr});
                });
                Navigator.pop(ctx);
              },
              child: const Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentsTab(Color primary) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionHeader(Icons.payment, 'Configuración de Pagos', primary),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          color: Colors.grey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), 
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                  SwitchListTile(
                    title: const Text('Requerir Pago Adelantado', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Los clientes deben pagar para confirmar su cita'),
                    value: _requireAdvancePayment,
                    onChanged: (v) => setState(() => _requireAdvancePayment = v),
                    activeColor: primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (_requireAdvancePayment) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.percent, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Porcentaje de Anticipo: ${_advancePercentage.toInt()}%', style: const TextStyle(fontWeight: FontWeight.w500))),
                      ],
                    ),
                    Slider(
                      value: _advancePercentage,
                      min: 10,
                      max: 100,
                      divisions: 18,
                      label: '${_advancePercentage.toInt()}%',
                      activeColor: primary,
                      onChanged: (v) => setState(() => _advancePercentage = v),
                    ),
                    const Divider(height: 32),
                  _buildSectionHeader(Icons.account_balance_wallet_outlined, 'Pasarela de Pago', primary),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _paymentGateway,
                    decoration: InputDecoration(
                      labelText: 'Proveedor de Pagos',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'epaico', child: Text('ePaico (Recomendado)')),
                      DropdownMenuItem(value: 'mercadopago', child: Text('Mercado Pago')),
                      DropdownMenuItem(value: 'stripe', child: Text('Stripe')),
                    ],
                    onChanged: (v) {
                       if (v != null) setState(() => _paymentGateway = v);
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Modo de Pruebas (Sandbox)', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Simula transacciones sin dinero real'),
                    value: _paymentTestMode,
                    onChanged: (v) => setState(() => _paymentTestMode = v),
                    activeColor: Colors.orange,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  if (_paymentGateway == 'epaico') ...[
                    TextField(
                      controller: _epaicoPublicKeyController,
                      decoration: InputDecoration(
                        labelText: 'ePaico Public Key',
                        prefixIcon: const Icon(Icons.vpn_key_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _epaicoPrivateKeyController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'ePaico Private Key',
                        prefixIcon: const Icon(Icons.security),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ] else if (_paymentGateway == 'mercadopago') ...[
                    TextField(
                      controller: _mpPublicKeyController,
                      decoration: InputDecoration(
                        labelText: 'Mercado Pago Public Key (Access Token)',
                        prefixIcon: const Icon(Icons.vpn_key_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _mpPrivateKeyController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mercado Pago Client Secret',
                        prefixIcon: const Icon(Icons.security),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ] else if (_paymentGateway == 'stripe') ...[
                    TextField(
                      controller: _stripePublicKeyController,
                      decoration: InputDecoration(
                        labelText: 'Stripe Publishable Key',
                        prefixIcon: const Icon(Icons.vpn_key_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _stripePrivateKeyController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Stripe Secret Key',
                        prefixIcon: const Icon(Icons.security),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _requireAdvancePayment 
                    ? 'El sistema exigirá el comprobante o pago exitoso antes de que la cita pase a estado "Confirmada".' 
                    : 'Las citas se pueden confirmar manualmente. El pago se registrará en sitio.',
                  style: const TextStyle(fontSize: 13, color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color)),
      ],
    );
  }
}
