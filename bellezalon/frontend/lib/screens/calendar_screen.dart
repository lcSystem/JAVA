import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../utils/offline_guard.dart';
import '../services/settings_provider.dart';
import '../utils/formatters.dart';
import 'sales_screen.dart';
import 'chat_screen.dart';
import '../services/payments/payment_service.dart';
import '../services/payments/payment_result.dart';
import '../models/technical_sheet_models.dart';
import '../services/customer_state_engine.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<dynamic> _allCitas = [];
  Map<DateTime, List<dynamic>> _citasEvents = {};
  bool _loading = true;
  
  List<dynamic> _clientes = [];
  List<dynamic> _servicios = [];
  List<dynamic> _empleados = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final api = ApiService();
      final results = await Future.wait([
        api.getCitas(),
        api.getServicios(),
        api.getEmpleadosOnly(),
        api.userRole!.contains('Cliente') ? Future.value([]) : api.getClientesOnly(),
      ]);

      _allCitas = results[0];
      _servicios = results[1];
      _empleados = results[2];
      
      // Si el usuario es cliente, no mostrar administradores
      if (api.userRole!.contains('Cliente')) {
        _empleados = _empleados.where((e) => e['role_id'].toString() != '1').toList();
      }
      
      _clientes = results[3];

      // Group events by day
      _citasEvents = {};
      for (var cita in _allCitas) {
        if (cita['fecha_cita'] == null) continue;
        final date = DateTime.parse(cita['fecha_cita']);
        final day = DateTime(date.year, date.month, date.day);
        _citasEvents[day] ??= [];
        _citasEvents[day]!.add(cita);
      }
    } catch (e) {
      debugPrint("Error loading calendar data: $e");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _citasEvents[DateTime(day.year, day.month, day.day)] ?? [];
  }

  bool _isDateBlocked(DateTime date) {
    try {
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      final schedulesJson = settings.settings['blocked_schedules'] ?? '{}';
      final blockedSchedules = jsonDecode(schedulesJson);
      
      final dayMap = {
        DateTime.monday: 'monday',
        DateTime.tuesday: 'tuesday',
        DateTime.wednesday: 'wednesday',
        DateTime.thursday: 'thursday',
        DateTime.friday: 'friday',
        DateTime.saturday: 'saturday',
        DateTime.sunday: 'sunday',
      };
      
      final dayKey = dayMap[date.weekday];
      if (dayKey == null) return false;
      
      final dayConfig = blockedSchedules[dayKey];
      if (dayConfig == null) return false;
      
      return dayConfig['closed'] == true;
    } catch (e) {
      return false;
    }
  }

  bool _isTimeBlocked(DateTime date, String time) {
    try {
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      final schedulesJson = settings.settings['blocked_schedules'] ?? '{}';
      final blockedSchedules = jsonDecode(schedulesJson);
      
      final dayMap = {
        DateTime.monday: 'monday',
        DateTime.tuesday: 'tuesday',
        DateTime.wednesday: 'wednesday',
        DateTime.thursday: 'thursday',
        DateTime.friday: 'friday',
        DateTime.saturday: 'saturday',
        DateTime.sunday: 'sunday',
      };
      
      final dayKey = dayMap[date.weekday];
      if (dayKey == null) return false;
      
      final dayConfig = blockedSchedules[dayKey];
      if (dayConfig == null) return false;
      
      if (dayConfig['closed'] == true) return true;
      
      final blocks = dayConfig['blocks'] as List?;
      if (blocks != null) {
        for (final block in blocks) {
          final start = block['start'];
          final end = block['end'];
          if (time.compareTo(start) >= 0 && time.compareTo(end) < 0) {
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Color _estadoColor(String estado) {
    return switch (estado.toLowerCase()) {
      'confirmada' => Colors.green,
      'pendiente' => Colors.orange,
      'completada' => Colors.blue,
      'cancelada' => Colors.red,
      _ => Colors.grey,
    };
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCrearCita,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Cita'),
        backgroundColor: primary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : isDesktop
              ? Row(
                  children: [
                    Expanded(flex: 2, child: _buildCalendar(primary)),
                    const VerticalDivider(width: 1),
                    Expanded(flex: 1, child: _buildAgendaList(primary)),
                  ],
                )
              : Column(
                  children: [
                    _buildCalendar(primary),
                    const Divider(height: 1),
                    Expanded(child: _buildAgendaList(primary)),
                  ],
                ),
    );
  }

  Widget _buildCalendar(Color primary) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey[200]!)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
          locale: 'es_ES',
          firstDay: DateTime.now().subtract(const Duration(days: 365)),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          enabledDayPredicate: (day) => !_isDateBlocked(day),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() => _calendarFormat = format);
          },
          eventLoader: _getEventsForDay,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(color: primary.withOpacity(0.2), shape: BoxShape.circle),
            todayTextStyle: TextStyle(color: primary, fontWeight: FontWeight.bold),
            selectedDecoration: BoxDecoration(color: primary, shape: BoxShape.circle),
            markerDecoration: BoxDecoration(color: primary, shape: BoxShape.circle),
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: true,
            titleCentered: true,
            formatButtonDecoration: BoxDecoration(
              border: Border.all(color: primary.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(12),
            ),
            formatButtonTextStyle: TextStyle(color: primary),
          ),
        ),
      ),
    );
  }

  Widget _buildAgendaList(Color primary) {
    final events = _getEventsForDay(_selectedDay ?? _focusedDay);
    final dateStr = DateFormat('EEEE, d MMMM', 'es_ES').format(_selectedDay ?? _focusedDay);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.event_note, color: primary),
              const SizedBox(width: 10),
              Text(dateStr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              Text('${events.length} citas', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ),
        Expanded(
          child: events.isEmpty
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.event_available, size: 48, color: Colors.grey[300]), const SizedBox(height: 10), const Text('Sin citas para este día')]))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: events.length,
                  itemBuilder: (context, i) {
                    final c = events[i];
                    final isMasked = c['cliente_nombre'] == 'Ocupado';
                    final estado = c['estado'] ?? 'pendiente';

                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[200]!)),
                      child: ListTile(
                        leading: Container(
                          width: 4, height: 40,
                          decoration: BoxDecoration(color: _estadoColor(estado), borderRadius: BorderRadius.circular(2)),
                        ),
                        title: Text(
                          isMasked ? 'ESPACIO OCUPADO' : (c['cliente_nombre'] ?? 'Sin nombre'),
                          style: TextStyle(fontWeight: FontWeight.bold, color: isMasked ? Colors.grey[400] : Colors.black87),
                        ),
                        subtitle: Text(
                          isMasked ? 'Horario reservado' : '${c['servicio_nombre']} • ${c['empleado_nombre']}',
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        trailing: Consumer<SettingsProvider>(
                          builder: (context, settings, _) => Text(
                            formatTime(c['hora_cita'], settings.timeFormat),
                            style: TextStyle(fontWeight: FontWeight.bold, color: primary),
                          ),
                        ),
                        onTap: isMasked ? null : () => _showEstadoDialog(c),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showCrearCita() {
    int? clienteId, servicioId, empleadoId;
    final fechaCtrl = TextEditingController(text: DateFormat('yyyy-MM-dd').format(_selectedDay ?? _focusedDay));
    final horaCtrl = TextEditingController();
    final comentCtrl = TextEditingController();
    bool acceptedConsent = false;
    final api = ApiService();
    final primary = Theme.of(context).primaryColor;

    String searchSvc = '';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (stfCtx, setStfState) {
        final filteredServicios = _servicios.where((s) => 
          s['nombre'].toString().toLowerCase().contains(searchSvc.toLowerCase())
        ).toList();

        return AlertDialog(
          title: const Text('Agendar Cita', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!api.userRole!.contains('Cliente')) ...[
                    const Text('Cliente', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      hint: const Text('Seleccionar cliente'),
                      items: _clientes.map<DropdownMenuItem<int>>((c) => DropdownMenuItem(value: c['id'] as int, child: Text(c['full_name'] ?? c['username']))).toList(),
                      onChanged: (v) => clienteId = v,
                    ),
                    const SizedBox(height: 20),
                  ] else ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(backgroundColor: primary.withOpacity(0.1), child: Icon(Icons.person, color: primary)),
                    title: const Text('Agendando como:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    subtitle: Text(api.userName ?? 'Cliente', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  const SizedBox(height: 20),
                ],

                // Selección de Servicio Visual
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Seleccionar Servicio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    if (searchSvc.isNotEmpty) 
                      Text('${filteredServicios.length} resultados', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (v) => setStfState(() => searchSvc = v),
                  decoration: InputDecoration(
                    hintText: 'Buscar servicio...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: searchSvc.isNotEmpty 
                      ? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () => setStfState(() => searchSvc = ''))
                      : null,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 145,
                  child: filteredServicios.isEmpty
                      ? Center(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 40, color: Colors.grey[300]),
                            const Text('No se encontraron servicios', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filteredServicios.length,
                          itemBuilder: (context, index) {
                            final s = filteredServicios[index];
                            final isSelected = servicioId == s['id'];
                            final imagenes = s['imagenes'] as List? ?? [];
                            final String? imageUrl = imagenes.isNotEmpty ? '${ApiService.assetsBaseUrl}${imagenes[0]['image_url']}' : null;

                            return GestureDetector(
                              onTap: () => setStfState(() => servicioId = s['id']),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 150,
                                margin: const EdgeInsets.only(right: 12, bottom: 4),
                                decoration: BoxDecoration(
                                  color: isSelected ? primary.withOpacity(0.05) : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: isSelected ? primary : Colors.grey[300]!, width: isSelected ? 2 : 1),
                                  boxShadow: isSelected ? [BoxShadow(color: primary.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))] : null,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: imageUrl != null
                                            ? CachedNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover, width: double.infinity, errorWidget: (context, error, stackTrace) => Container(color: Colors.grey[200], child: const Icon(Icons.broken_image, size: 30, color: Colors.grey)))
                                            : Container(color: primary.withOpacity(0.1), child: Center(child: Icon(Icons.spa, color: primary.withOpacity(0.4), size: 30))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(s['nombre'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(formatCurrency(s['precio']), style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 10)),
                                                if (isSelected) Icon(Icons.check_circle, color: primary, size: 14),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 20),

                // Personal y Horario
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Personal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      hint: const Text('Opcional'),
                      items: _empleados.map<DropdownMenuItem<int>>((e) => DropdownMenuItem(value: e['id'] as int, child: Text(e['full_name'] ?? e['username']))).toList(),
                      onChanged: (v) => empleadoId = v,
                    ),
                    const SizedBox(height: 16),
                    const Text('Hora', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: horaCtrl,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'HH:MM',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        suffixIcon: const Icon(Icons.access_time, size: 20),
                      ),
                      onTap: () async {
                        final settings = Provider.of<SettingsProvider>(context, listen: false);
                        final t = await showTimePicker(
                          context: context, 
                          initialTime: TimeOfDay.now(),
                          builder: (context, child) {
                            return MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                alwaysUse24HourFormat: settings.use24HourFormat,
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (t != null) {
                          final timeStr = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
                          if (_isTimeBlocked(_selectedDay ?? DateTime.now(), timeStr)) {
                            ScaffoldMessenger.of(stfCtx).showSnackBar(const SnackBar(
                              content: Text('❌ Este horario está bloqueado por el administrador.'),
                              backgroundColor: Colors.red,
                            ));
                            horaCtrl.clear();
                          } else {
                            horaCtrl.text = timeStr;
                          }
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Text('Comentarios (Opcional)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                TextField(
                  controller: comentCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Ej: Alergia al látex, prefiere agua tibia...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                if (api.userRole!.contains('Cliente')) ...[
                  const SizedBox(height: 20),
                  const Divider(),
                  CheckboxListTile(
                    value: acceptedConsent,
                    onChanged: (v) => setStfState(() => acceptedConsent = v!),
                    title: const Text('Acepto que mis datos de salud son verídicos y autorizo el tratamiento de mi ficha técnica.', style: TextStyle(fontSize: 12)),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ]),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () async {
                if (servicioId == null || (clienteId == null && !api.userRole!.contains('Cliente')) || horaCtrl.text.isEmpty) {
                  ScaffoldMessenger.of(stfCtx).showSnackBar(const SnackBar(content: Text('Por favor completa los campos y selecciona un servicio.'), backgroundColor: Colors.orange));
                  return;
                }

                if (api.userRole!.contains('Cliente') && !acceptedConsent) {
                  ScaffoldMessenger.of(stfCtx).showSnackBar(const SnackBar(content: Text('Debes aceptar el consentimiento legal para continuar.'), backgroundColor: Colors.orange));
                  return;
                }

                final targetSvc = _servicios.firstWhere((s) => s['id'] == servicioId);
                final settings = Provider.of<SettingsProvider>(context, listen: false);
                
                String? paymentRef;
                bool isPaid = false;
                double depositAmount = 0;

                // --- NUEVO FLUJO DE PAGO ADELANTADO EN RESERVA ---
                if (api.userRole!.contains('Cliente') && settings.requireAdvancePayment) {
                  final double totalPrice = double.tryParse(targetSvc['precio']?.toString() ?? '0') ?? 0;
                  depositAmount = (totalPrice * settings.advancePaymentPercentage) / 100;

                  if (depositAmount > 0) {
                    final result = await PaymentService().processAdvancePayment(context, depositAmount, {
                      ...targetSvc,
                      'client_name': api.userName,
                      'type': 'Anticipo (${settings.advancePaymentPercentage}%)'
                    });

                    if (result.success && result.status == 'paid') {
                      isPaid = true;
                      paymentRef = result.transactionId;
                    } else if (result.status == 'cancelled') {
                      return; // Usuario canceló el modal de pago, no se agenda nada.
                    } else {
                      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Error en el pago: ${result.message}'), backgroundColor: Colors.red));
                      return;
                    }
                  }
                }

                final data = {
                  'cliente_id': api.userRole!.contains('Cliente') ? api.userId : clienteId,
                  'servicio_id': servicioId,
                  'empleado_id': empleadoId,
                  'fecha_cita': fechaCtrl.text,
                  'hora_cita': horaCtrl.text,
                  'comentarios': comentCtrl.text,
                  'payment_status': isPaid ? 'paid' : 'pending',
                  'transaction_id': paymentRef,
                  'deposit_amount': depositAmount,
                };

                try {
                final res = await api.createCita(data);
                if (res != null && res.containsKey('id')) {
                  Navigator.pop(ctx);
                  _loadData();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(isPaid ? '✅ Cita agendada y depósito pagado' : '✅ Cita agendada correctamente'), 
                    backgroundColor: Colors.green
                  ));
                } else if (res != null && res.containsKey('error')) {
                  ScaffoldMessenger.of(stfCtx).showSnackBar(SnackBar(
                    content: Text('❌ Error: ${res['error']}'),
                    backgroundColor: Colors.red,
                  ));
                }
                } on OfflineException catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]),
                    backgroundColor: Colors.red[700],
                  ));
                }
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Confirmar Agendamiento'),
            ),
          ],
        );
      }),
    );
  }

  void _showEstadoDialog(Map<String, dynamic> cita) {
    if (ApiService().userRole!.contains('Cliente') && cita['id'] == 0) return;
    final primary = Theme.of(context).primaryColor;
    final api = ApiService();
    final isClient = api.userRole!.contains('Cliente');
    final estado = (cita['estado'] ?? 'pendiente').toString().toLowerCase();

    showDialog(
      context: context,
      builder: (ctx) => FutureBuilder<Map<String, dynamic>?>(
        future: !isClient ? api.getUserProfile(cita['cliente_id']) : Future.value(null),
        builder: (context, snapshot) {
          final clientData = snapshot.data;
          TechnicalSheet? sheet;
          if (clientData != null && clientData['technical_sheet'] != null) {
            sheet = TechnicalSheet.fromJson(clientData['technical_sheet']);
          }

          return AlertDialog(
            title: const Text('Gestionar Cita'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isClient && sheet != null) _buildRiskBanner(sheet, cita),
                  if (!isClient && sheet != null) const SizedBox(height: 16),
        // --- OPCIÓN DE CHAT (Si está pendiente) ---
        if (estado == 'pendiente')
          ListTile(
            leading: Icon(Icons.chat, color: primary),
            title: const Text('ABRIR CHAT'),
            subtitle: const Text('Hablar sobre esta cita'),
            onTap: () {
              Navigator.pop(ctx);
              final String otherName = isClient 
                ? (cita['empleado_nombre'] ?? 'Empleado') 
                : (cita['cliente_nombre'] ?? 'Cliente');
              
              Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(
                citaId: int.parse(cita['id'].toString()),
                otherPartyName: otherName,
                isChatEnabled: true,
              )));
            },
          ),
        
        if (estado == 'pendiente') const Divider(),

        if (!isClient)
          for (final est in ['pendiente', 'confirmada', 'completada', 'cancelada', 'no_asistio'])
            ListTile(
              leading: Icon(Icons.circle, color: _estadoColor(est), size: 14),
              title: Text(est.toUpperCase()),
              selected: estado == est,
              onTap: () async {
                if (est == estado) {
                  Navigator.pop(ctx);
                  return;
                }

                if (est == 'cancelada') {
                  // Confirmación de cancelación
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (cctx) => AlertDialog(
                      title: const Text('Confirmar Cancelación'),
                      content: const Text('¿Realmente deseas cancelar esta cita?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(cctx, false), child: const Text('NO')),
                        FilledButton(onPressed: () => Navigator.pop(cctx, true), child: const Text('SÍ, CANCELAR')),
                      ],
                    ),
                  );
                  if (confirm != true) return;
                }

                if (est == 'cancelada' && estado == 'completada') {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No es posible cancelar una cita que ya fue completada'), backgroundColor: Colors.orange));
                  return;
                }

                if (est == 'confirmada') {
                  final settings = Provider.of<SettingsProvider>(context, listen: false);

                  if (settings.requireAdvancePayment) {
                    // --- CASO 2: PAGO CON ANTICIPO / DEPÓSITO ---
                    final double amount = double.tryParse(cita['servicio_precio']?.toString() ?? '0') ?? 0;
                    
                    final result = await PaymentService().processAdvancePayment(context, amount, cita);

                    if (result.success && result.status == 'paid') {
                      try {
                        final r = await api.updateCita(cita['id'], {
                          'estado': est,
                          'payment_status': 'paid',
                          'transaction_id': result.transactionId
                        });
                        if (mounted) Navigator.pop(ctx);
                        _loadData();
                        if (r != null && r.containsKey('error')) {
                          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ ${r['error']}'), backgroundColor: Colors.red));
                        } else {
                          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Pago confirmado y Cita Agendada'), backgroundColor: Colors.green));
                        }
                      } on OfflineException catch (e) {
                        if (mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]), backgroundColor: Colors.red[700]));
                        }
                      }
                    } else if (result.status == 'cancelled') {
                       // User just closed the modal, do nothing or show info
                    } else {
                       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ Pago no realizado: ${result.message ?? "Error desconocido"}'), backgroundColor: Colors.orange));
                    }
                  } else {
                    // --- CASO 1: PAGO EN SITIO / PRESENCIAL ---
                    final saleCreated = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => Scaffold(
                      appBar: AppBar(
                        title: const Text('Registrar Pago / Venta'),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      body: SalesScreen(
                        initialClienteId: cita['cliente_id'],
                        initialServicioId: cita['servicio_id'],
                        initialCitaId: cita['id'],
                      ),
                    )));

                    if (saleCreated == true) {
                      try {
                        final r = await api.updateCita(cita['id'], {'estado': est});
                        if (mounted) Navigator.pop(ctx);
                        _loadData();
                        if (r != null && r.containsKey('error')) {
                          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ ${r['error']}'), backgroundColor: Colors.red));
                        }
                      } on OfflineException catch (e) {
                        if (mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]), backgroundColor: Colors.red[700]));
                        }
                      }
                    } else {
                      if (mounted) Navigator.pop(ctx);
                    }
                  }
                } else {
                  try {
                  final r = await api.updateCita(cita['id'], {'estado': est});
                  Navigator.pop(ctx);
                  _loadData();
                  if (r != null && r.containsKey('error')) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ ${r['error']}'), backgroundColor: Colors.red));
                  }
                  } on OfflineException catch (e) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]), backgroundColor: Colors.red[700]));
                  }
                }
              },
            )
        else
          ListTile(
            leading: const Icon(Icons.cancel, color: Colors.red),
            title: const Text('CANCELAR CITA'),
            onTap: () async {
              if (estado == 'confirmada' || estado == 'completada') {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('❌ No es posible cancelar una cita confirmada o completada.'),
                  backgroundColor: Colors.orange,
                  duration: Duration(seconds: 4),
                ));
                return;
              }
              
              if (estado == 'cancelada') {
                Navigator.pop(ctx);
                return;
              }

              // --- VALIDACIÓN DE CANCELACIÓN PARA CLIENTE ---
              final confirm = await showDialog<bool>(
                context: context,
                builder: (cctx) => AlertDialog(
                  title: const Text('¿Cancelar Cita?'),
                  content: const Text('¿Estás seguro de que deseas cancelar tu cita? Esta acción no se puede deshacer.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(cctx, false), child: const Text('NO, VOLVER')),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(cctx, true), 
                      child: const Text('SÍ, CANCELAR')
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                try {
                final res = await api.updateCita(cita['id'], {'estado': 'cancelada'});
                Navigator.pop(ctx);
                _loadData();
                if (res != null && res.containsKey('error')) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('❌ ${res['error']}'), backgroundColor: Colors.red));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Cita cancelada'), backgroundColor: Colors.green));
                }
                } on OfflineException catch (e) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.wifi_off, color: Colors.white), const SizedBox(width: 8), Expanded(child: Text(e.message))]), backgroundColor: Colors.red[700]));
                }
              }
            },
          ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRiskBanner(TechnicalSheet sheet, Map<String, dynamic> cita) {
    // Current service context
    final serviceContext = {
      'type': cita['servicio_nombre']?.toString().toLowerCase() ?? '',
      'chemicals': true, // Assume chemicals for salon safety by default
    };

    final evaluation = CustomerDecisionEngine.evaluate(sheet, serviceContext);
    final decision = evaluation['decision'];
    final reasons = List<String>.from(evaluation['reasons'] ?? []);

    if (decision == 'PASS' && reasons.isEmpty) return const SizedBox.shrink();

    Color color = decision == 'BLOCK' ? Colors.red : Colors.orange;
    IconData icon = decision == 'BLOCK' ? Icons.gavel : Icons.warning;

    return Card(
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: color)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 10),
                Text(
                  decision == 'BLOCK' ? 'ALERTA DE RIESGO CRÍTICO' : 'RECOMENDACIÓN DE SEGURIDAD',
                  style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13),
                ),
              ],
            ),
            if (reasons.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...reasons.map((r) => Text('• $r', style: const TextStyle(fontSize: 12))),
            ]
          ],
        ),
      ),
    );
  }
}
