import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/api_service.dart';
import '../services/settings_provider.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';
import '../common/branding_logo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.forward();
  }

  @override
  void dispose() { _animController.dispose(); super.dispose(); }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor completa todos los campos'), backgroundColor: Colors.orange),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final pos = await _determinePosition();
      final result = await ApiService().login(
        _usernameController.text, 
        _passwordController.text,
        lat: pos?.latitude,
        lng: pos?.longitude,
      );
      if (!mounted) return;
      if (result['success'] == true) {
        // Register FCM Token
        try {
          if (!kIsWeb) {
            String? fcmToken = await FirebaseMessaging.instance.getToken();
            if (fcmToken != null) {
              await ApiService().updateFcmToken(fcmToken);
            }
          }
        } catch (e) {
          debugPrint("Error fetching FCM token: $e");
        }

        if (mounted) {
          await Provider.of<SettingsProvider>(context, listen: false).fetchSettings();
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Bienvenido ${ApiService().userName}!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const DashboardScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${result['error']}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e'), backgroundColor: Colors.orange),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final primary = settings.primaryColor;

    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [primary.withOpacity(0.08), Colors.white, primary.withOpacity(0.05)],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: isMobile ? const EdgeInsets.symmetric(horizontal: 20, vertical: 40) : const EdgeInsets.all(32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: isMobile 
                  ? _buildLoginForm(primary, settings, isMobile: true)
                  : Card(
                      elevation: 12,
                      shadowColor: primary.withOpacity(0.3),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: _buildLoginForm(primary, settings, isMobile: false),
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(Color primary, SettingsProvider settings, {required bool isMobile}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [primary, primary.withOpacity(0.7)]),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: primary.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: const BrandingLogo(size: 60, iconSize: 48),
        ),
        const SizedBox(height: 24),
        Text(settings.salonName, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: primary, letterSpacing: -0.5)),
        const SizedBox(height: 4),
        Text('Sistema Empresarial', style: TextStyle(fontSize: 13, color: Colors.grey[500], letterSpacing: 2)),
        const SizedBox(height: 36),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Usuario', prefixIcon: Icon(Icons.person_outline, color: primary),
            border: isMobile ? InputBorder.none : OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            enabledBorder: isMobile ? UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))) : null,
            focusedBorder: isMobile 
              ? UnderlineInputBorder(borderSide: BorderSide(color: primary, width: 2))
              : OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: primary, width: 2)),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          onSubmitted: (_) => _handleLogin(),
          decoration: InputDecoration(
            labelText: 'Contraseña', prefixIcon: Icon(Icons.lock_outline, color: primary),
            suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)),
            border: isMobile ? InputBorder.none : OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            enabledBorder: isMobile ? UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))) : null,
            focusedBorder: isMobile 
              ? UnderlineInputBorder(borderSide: BorderSide(color: primary, width: 2))
              : OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: primary, width: 2)),
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity, height: 52,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: isMobile ? 0 : 4, shadowColor: primary.withOpacity(0.4),
            ),
            child: _isLoading
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
              : const Text('INGRESAR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.5)),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen())),
          icon: const Icon(Icons.person_add_outlined, size: 18),
          label: const Text('¿No tienes cuenta? Regístrate aquí'),
        ),
      ],
    );
  }
}
