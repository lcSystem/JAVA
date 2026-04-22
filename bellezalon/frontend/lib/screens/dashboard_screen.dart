import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/settings_provider.dart';
import 'calendar_screen.dart';
import 'servicio_screen.dart';
import 'sales_screen.dart';
import 'inventory_screen.dart';
import 'reports_screen.dart';
import 'admin_settings_screen.dart';
import 'roles_screen.dart';
import 'users_screen.dart';
import 'profile_screen.dart';
import 'map_monitoring_screen.dart';
import 'history_screen.dart';
import 'chat_list_screen.dart';
import 'chat_screen.dart';
import 'notification_list_screen.dart';
import 'home_screen.dart';
import 'pqrs_list_screen.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/in_app_notification_service.dart';
import '../services/connectivity_service.dart';
import '../services/api_service.dart' show OfflineException;
// NO import dart:io to avoid web crashes
import 'package:flutter/foundation.dart'; // for kIsWeb if needed
import '../common/branding_logo.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;
  final api = ApiService();
  int _unreadCount = 0;
  Timer? _notifTimer;
  bool _isOffline = false;
  bool _showRestoredBanner = false;
  StreamSubscription<ConnectivityStatus>? _connectivitySub;

  @override
  void initState() {
    super.initState();
    _pollNotifications();
    _notifTimer = Timer.periodic(const Duration(seconds: 30), (_) => _pollNotifications());
    
    // Internal Notification Toast Service
    InAppNotificationService().startPolling();
    InAppNotificationService().notificationsStream.listen((n) {
      if (mounted) _showNotificationToast(n);
    });

    _refreshFcmToken();

    // Monitoreo de conectividad en tiempo real
    _isOffline = !ConnectivityService.instance.isOnline;
    _connectivitySub = ConnectivityService.instance.onStatusChange.listen((status) {
      if (!mounted) return;
      switch (status) {
        case ConnectivityStatus.offline:
          setState(() { _isOffline = true; _showRestoredBanner = false; });
          break;
        case ConnectivityStatus.restored:
          setState(() { _isOffline = false; _showRestoredBanner = true; });
          // Auto-ocultar banner verde después de 4 segundos
          Future.delayed(const Duration(seconds: 4), () {
            if (mounted) setState(() => _showRestoredBanner = false);
          });
          break;
        case ConnectivityStatus.online:
          setState(() { _isOffline = false; });
          break;
      }
    });
  }

  Future<void> _refreshFcmToken() async {
    try {
      if (!kIsWeb) {
        String? token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await api.updateFcmToken(token);
        }
      }
    } catch (e) {
      debugPrint("Error refreshing FCM token: $e");
    }
  }

  @override
  void dispose() {
    _notifTimer?.cancel();
    _connectivitySub?.cancel();
    InAppNotificationService().stopPolling();
    super.dispose();
  }

  Future<void> _pollNotifications() async {
    final count = await api.getUnreadCount();
    if (mounted) setState(() => _unreadCount = count);
  }

  void _showNotificationToast(dynamic n) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _InAppToast(
        notification: n,
        onTap: () {
          entry.remove();
          // Reuse navigation logic from NotificationListScreen if possible, 
          // or implement inline:
          _handleNotificationClick(n);
        },
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
    
    // Auto-dismiss after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (entry.mounted) entry.remove();
    });
  }

  void _handleNotificationClick(dynamic n) {
    if (n['context_type'] == 'chat' && n['context_id'] != null) {
      final citaId = int.tryParse(n['context_id'].toString());
      if (citaId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              citaId: citaId,
              otherPartyName: n['title'] ?? 'Chat',
              isChatEnabled: true,
            ),
          ),
        );
      }
    }
    // Update unread count
    _pollNotifications();
  }

  List<_NavItem> get _navItems {
    final items = <_NavItem>[
      _NavItem(Icons.person, 'Mi Perfil', const ProfileScreen()),
      _NavItem(Icons.home, 'Home', const HomeScreen()),
      _NavItem(Icons.calendar_month, 'Agenda', const CalendarScreen()),
      _NavItem(Icons.point_of_sale, 'Ventas', const SalesScreen()),
      _NavItem(Icons.spa, 'Servicios', const ServicioScreen()),
      _NavItem(Icons.inventory_2, 'Inventario', const InventoryScreen()),
      _NavItem(Icons.analytics, 'Reportes', const ReportsScreen()),
      _NavItem(Icons.admin_panel_settings, 'Roles y Permisos', const RolesScreen()),
      _NavItem(Icons.people_outline, 'Usuarios', const UsersScreen()),
      _NavItem(Icons.map, 'Mapa', const MapMonitoringScreen()),
      _NavItem(Icons.history, 'Historial', const HistoryScreen()),
      _NavItem(Icons.chat, 'Chat', const ChatListScreen()),
      _NavItem(Icons.support_agent, 'Soporte', const PqrsListScreen()),
      _NavItem(Icons.settings, 'Configuración', const AdminSettingsScreen()),
    ];
    final perms = api.permissions;
    return items.where((item) {
      if (item.title == 'Mi Perfil') return perms.contains('Mi Perfil');
      if (item.title == 'Mapa') return perms.contains('Monitoreo');
      if (item.title == 'Home') return perms.contains('Home');
      if (item.title == 'Chat' || item.title == 'Soporte') return true; // Everyone can access chat and support
      return perms.contains(item.title);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final navItems = _navItems;
    if (_selectedIndex >= navItems.length) _selectedIndex = 0;
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // Banner de conectividad
      appBar: (_isOffline || _showRestoredBanner) ? PreferredSize(
        preferredSize: const Size.fromHeight(36),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: double.infinity,
          color: _isOffline ? Colors.red[700] : Colors.green[600],
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isOffline ? Icons.wifi_off : Icons.wifi,
                  color: Colors.white, size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _isOffline ? 'Sin conexión a internet — Modo offline' : '¡Conexión restaurada!',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ) : null,
      bottomNavigationBar: isDesktop ? null : _buildMobileBottomNav(primary, navItems),
      body: isDesktop ? Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: _isSidebarCollapsed ? 80 : 250,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(4, 0))],
            ),
            child: _buildSidebarContent(primary, navItems, isDesktop: true),
          ),
          Expanded(
            child: Column(
              children: [
                // Top bar with notification bell
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      Text(navItems[_selectedIndex].title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
                      const Spacer(),
                      _buildNotificationBell(primary),
                    ],
                  ),
                ),
                Expanded(child: navItems[_selectedIndex].screen),
              ],
            ),
          ),
        ],
      ) : _buildMobileBody(navItems),
    );
  }

  Widget _buildMobileBody(List<_NavItem> navItems) {
    if (_selectedIndex < 3) {
      return Scaffold(
        appBar: AppBar(
          title: Text(navItems[_selectedIndex].title),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          actions: [
            _buildNotificationBell(Theme.of(context).primaryColor),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: _performLogout,
            ),
          ],
        ),
        body: navItems[_selectedIndex].screen,
      );
    }
    // "Menú" screen for mobile
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        actions: [
          _buildNotificationBell(Theme.of(context).primaryColor),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _performLogout,
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          for (int i = 3; i < navItems.length; i++)
            _buildMobileGridMenuTile(i, navItems[i]),
          _buildLogoutTile(Theme.of(context).primaryColor),
        ],
      ),
    );
  }

  Future<void> _performLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(children: [Icon(Icons.warning, color: Colors.orange), SizedBox(width: 8), Text('Cerrar Sesión')]),
        content: const Text('¿Estás seguro de que deseas salir?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir')),
        ],
      ),
    );
    if (confirm == true) {
      api.logout();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  Widget _buildLogoutTile(Color primary) {
    return InkWell(
      onTap: _performLogout,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.logout, size: 32, color: Colors.red)),
            const SizedBox(height: 12),
            const Text('Cerrar Sesión', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileGridMenuTile(int index, _NavItem item) {
    final primary = Theme.of(context).primaryColor;
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => Scaffold(
          appBar: AppBar(title: Text(item.title), backgroundColor: primary, foregroundColor: Colors.white),
          body: item.screen,
        )));
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: primary.withOpacity(0.1), shape: BoxShape.circle), child: Icon(item.icon, size: 32, color: primary)),
            const SizedBox(height: 12),
            Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileBottomNav(Color primary, List<_NavItem> navItems) {
    final displayItems = navItems.take(3).toList();
    int activeNavbarIndex = _selectedIndex < 3 ? _selectedIndex : 3;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int i = 0; i < displayItems.length; i++)
                _buildBottomNavItem(i, displayItems[i].icon, displayItems[i].title, primary, activeNavbarIndex),
              _buildBottomNavItem(3, Icons.menu, 'Menú', primary, activeNavbarIndex),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String title, Color primary, int activeIndex) {
    final selected = activeIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(color: selected ? primary.withOpacity(0.1) : Colors.transparent, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? primary : Colors.grey[400], size: 24),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: selected ? primary : Colors.grey[500], fontSize: 10, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarContent(Color primary, List<_NavItem> navItems, {bool isDesktop = false}) {
    return Column(
      children: [
        // Branding Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(_isSidebarCollapsed ? 12 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [primary, primary.withOpacity(0.8)]),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                if (isDesktop) Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(_isSidebarCollapsed ? Icons.menu : Icons.menu_open, color: Colors.white70),
                    onPressed: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
                  ),
                ),
                BrandingLogo(
                  size: _isSidebarCollapsed ? 40 : 56,
                  iconSize: _isSidebarCollapsed ? 24 : 32,
                  isCircular: true,
                ),
                if (!_isSidebarCollapsed) ...[
                  const SizedBox(height: 12),
                  Consumer<SettingsProvider>(
                    builder: (context, sp, _) => Text(
                      sp.settings['salon_name'] ?? 'Salón Belleza Pro',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      '${api.userName ?? 'Admin'} • ${(api.userRole ?? 'admin').toUpperCase()}',
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Nav Items
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: _isSidebarCollapsed ? 4 : 8),
            children: [
              for (int i = 0; i < navItems.length; i++)
                _buildNavTile(i, navItems[i], primary),
            ],
          ),
        ),
        // Logout
        Padding(
          padding: EdgeInsets.all(_isSidebarCollapsed ? 4 : 12),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Row(children: [Icon(Icons.warning, color: Colors.orange), SizedBox(width: 8), Text('Cerrar Sesión')]),
                    content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Cerrar Sesión')
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  api.logout();
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
              style: OutlinedButton.styleFrom(
                padding: _isSidebarCollapsed ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 12),
                foregroundColor: Colors.red[400], side: BorderSide(color: Colors.red[200]!)
              ),
              child: _isSidebarCollapsed 
                 ? const Icon(Icons.logout, size: 20) 
                 : FittedBox(
                     fit: BoxFit.scaleDown,
                     child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.logout, size: 18), SizedBox(width: 8), Text('Cerrar Sesión')]),
                   ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavTile(int index, _NavItem item, Color primary) {
    final selected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: selected ? primary.withOpacity(0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() => _selectedIndex = index);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _isSidebarCollapsed ? 0 : 16, vertical: 14),
            child: Row(
              mainAxisAlignment: _isSidebarCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
              mainAxisSize: _isSidebarCollapsed ? MainAxisSize.min : MainAxisSize.max,
              children: [
                Icon(item.icon, size: 24, color: selected ? primary : Colors.grey[600]),
                if (!_isSidebarCollapsed) ...[
                  const SizedBox(width: 14),
                  Expanded(child: Text(item.title, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.w600, color: selected ? primary : Colors.grey[700], fontSize: 14), overflow: TextOverflow.ellipsis, maxLines: 1)),
                  if (selected) Container(width: 4, height: 20, decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(4))),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationBell(Color primary) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, color: primary, size: 26),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationListScreen())).then((_) => _pollNotifications());
          },
        ),
        if (_unreadCount > 0)
          Positioned(
            right: 6, top: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text('$_unreadCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            ),
          ),
      ],
    );
  }

  // Old _showNotificationPanel removed, now uses full-screen NotificationListScreen

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'Ahora';
      if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes}m';
      if (diff.inHours < 24) return 'Hace ${diff.inHours}h';
      return '${dt.day}/${dt.month}';
    } catch (_) { return ''; }
  }

  // BrandingLogo handles the placeholder icon automatically
}

class _NavItem {
  final IconData icon;
  final String title;
  final Widget screen;

  _NavItem(this.icon, this.title, this.screen);
}

class _InAppToast extends StatefulWidget {
  final dynamic notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _InAppToast({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  State<_InAppToast> createState() => _InAppToastState();
}

class _InAppToastState extends State<_InAppToast> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final primary = settings.primaryColor;

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SlideTransition(
          position: _offsetAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 400, // Max width for large screens
                  constraints: const BoxConstraints(maxWidth: double.infinity),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: primary.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.notification['context_type'] == 'chat' ? Icons.chat : Icons.notifications,
                          color: primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.notification['title'] ?? 'Nueva Notificación',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              widget.notification['message'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey[600], fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onDismiss,
                        icon: const Icon(Icons.close, size: 18),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
