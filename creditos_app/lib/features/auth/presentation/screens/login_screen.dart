import 'dart:ui';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../configuracion/providers/config_provider.dart';
import '../providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/app_config.dart';
import '../../../../core/services/service_health_checker.dart';
import '../../../../core/utils/logo_asset_resolver.dart';
/// Premium login screen with glassmorphism, dynamic branding, and animations.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _cedulaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      // Check microservice health before login
      final downServices = await ServiceHealthChecker.getDownServices();
      if (downServices.isNotEmpty) {
        if (mounted) {
          setState(() => _isLoading = false);
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 28),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Módulos no disponibles', style: TextStyle(fontSize: 17)),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Faltan módulos por ejecutar. Los siguientes servicios no están respondiendo:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  ...downServices.map((name) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        const Icon(Icons.cancel, color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Entendido'),
                ),
              ],
            ),
          );
        }
        return;
      }

      await ref.read(authProvider.notifier).login(
            cedula: _cedulaController.text.trim(),
            password: _passwordController.text,
          );
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(designConfigProvider);
    final size = MediaQuery.of(context).size;

    return configAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => _buildLoginBody(
        const AppDesignConfig(),
        size,
      ),
      data: (config) => _buildLoginBody(config, size),
    );
  }

  Widget _buildLoginBody(AppDesignConfig config, Size size) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient or image
          Positioned.fill(
            child: config.loginBgImageUrl != null &&
                    config.loginBgImageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: config.loginBgImageUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => _gradientBg(config),
                  )
                : _gradientBg(config),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo
                        _buildLogo(config),
                        const SizedBox(height: 16),
                        // Org name
                        Text(
                          config.orgName,
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Welcome message
                        Text(
                          config.welcomeMessage,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Glass card with form
                        _buildGlassCard(config),
                        const SizedBox(height: 24),
                        // Support info
                        Text(
                          '¿Necesitas ayuda? ${config.supportPhone}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientBg(AppDesignConfig config) {
    return Container(
      color: config.backgroundColor,
    );
  }

  Widget _buildLogo(AppDesignConfig config) {
    // Priority:
    // 1. Persistent Local Logo (Most recent downloaded)
    // 2. Remote URL (Live)
    // 3. Asset Fallback (Default)
    
    return _buildPersistentLogo(config);
  }

  Widget _buildPersistentLogo(AppDesignConfig config) {
    if (config.logoBytes != null && config.logoBytes!.isNotEmpty) {
      // Determine if it's an SVG by checking the URL or content magic numbers if needed
      // but for now we rely on the extension in the URL
      final isSvg = config.logoUrl?.toLowerCase().endsWith('.svg') ?? false;
      
      try {
        return isSvg
            ? SvgPicture.memory(
                config.logoBytes!, 
                height: 80,
                placeholderBuilder: (context) => _buildAssetLogo(config, true),
              )
            : Image.memory(
                config.logoBytes!, 
                height: 80,
                errorBuilder: (context, error, stackTrace) => _buildNetworkLogo(config),
              );
      } catch (e) {
        debugPrint('DEBUG: Error renderizando logo de caché: $e');
      }
    }
    return _buildNetworkLogo(config);
  }

  Widget _buildNetworkLogo(AppDesignConfig config) {
    if (config.logoUrl == null || config.logoUrl!.isEmpty) {
      return _buildAssetLogo(config, false);
    }

    final isSvg = config.logoUrl!.toLowerCase().endsWith('.svg');

    // We use a FutureBuilder to handle the "Failed to fetch" (CORS) or other network errors
    // so we don't get stuck in the loading state forever.
    return FutureBuilder<Uint8List?>(
      future: _fetchLogoBytes(config.logoUrl!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildAssetLogo(config, true);
        }
        
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
          debugPrint('DEBUG: Error o Timeout cargando logo de red, usando fallback.');
          return _buildAssetLogo(config, false);
        }

        final bytes = snapshot.data!;
        try {
          return isSvg
              ? SvgPicture.memory(
                  bytes,
                  height: 80,
                  placeholderBuilder: (context) => _buildAssetLogo(config, true),
                )
              : Image.memory(
                  bytes,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) => _buildAssetLogo(config, false),
                );
        } catch (e) {
          return _buildAssetLogo(config, false);
        }
      },
    );
  }

  /// Helper to fetch logo bytes with a timeout to avoid hanging UI
  Future<Uint8List?> _fetchLogoBytes(String url) async {
    try {
      final dio = Dio();
      final response = await dio.get<Uint8List>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      return response.data;
    } catch (e) {
      debugPrint('DEBUG: Logo remoto no alcanzable (servidor inactivo o CORS). Usando logo local por defecto.');
      return null;
    }
  }

  Widget _buildAssetLogo(AppDesignConfig config, bool isLoading) {
    return FutureBuilder<String?>(
      future: LogoAssetResolver.resolve(),
      builder: (context, snapshot) {
        final logoPath = snapshot.data;
        return Stack(
          alignment: Alignment.center,
          children: [
            if (logoPath != null && LogoAssetResolver.isSvg(logoPath))
              SvgPicture.asset(
                logoPath,
                height: 80,
                placeholderBuilder: (_) => _logoPlaceholder(),
              )
            else if (logoPath != null)
              Image.asset(
                logoPath,
                height: 80,
                errorBuilder: (_, __, ___) => _logoPlaceholder(),
              )
            else
              _logoPlaceholder(),
            if (isLoading)
              const SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white30),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _logoPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: const Icon(
        Icons.account_balance,
        size: 40,
        color: Colors.white70,
      ),
    );
  }

  Widget _buildGlassCard(AppDesignConfig config) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 420),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Iniciar Sesión',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ingresa con tu número de cédula',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Cédula field
                  TextFormField(
                    controller: _cedulaController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      label: 'Número de Cédula',
                      icon: Icons.badge_outlined,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Ingrese su cédula';
                      if (v.length < 5) return 'Cédula inválida';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      label: 'Contraseña',
                      icon: Icons.lock_outline,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.white54,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (v) => v == null || v.length < 6
                        ? 'Mínimo 6 caracteres'
                        : null,
                    onFieldSubmitted: (_) => _handleLogin(),
                  ),
                  const SizedBox(height: 16),
                  // Forgot Password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Funcionalidad en desarrollo')),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: config.primaryColor.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [config.primaryColor, config.secondaryColor],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: config.primaryColor.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Ingresar',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white54),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white.withOpacity(0.08),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
    );
  }
}
