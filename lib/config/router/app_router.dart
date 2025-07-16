import 'package:dsimcaf_1/presentation/pages/api_configuration/api_configuration_page.dart';
import 'package:dsimcaf_1/presentation/pages/areas%20de%20responsabilidad/areas_de_responsable_screen.dart';
import 'package:dsimcaf_1/presentation/pages/activos_fijos/assets_page.dart';
import 'package:dsimcaf_1/presentation/pages/configuracion/config_page.dart';
import 'package:dsimcaf_1/presentation/pages/login/login_page.dart';
import 'package:dsimcaf_1/presentation/pages/reponsable/responsable_screen.dart';
import 'package:dsimcaf_1/presentation/pages/herramientas/herramientas_page.dart';
import 'package:dsimcaf_1/presentation/pages/treeview/treeview_page.dart';
import 'package:dsimcaf_1/presentation/pages/verificafion/verificacion_page.dart';
import 'package:dsimcaf_1/presentation/providers/user/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dsimcaf_1/presentation/providers/api_configuration_provider.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  redirect: (context, state) {
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'initial',
      builder: (context, state) => const InitialPage(),
    ),
    GoRoute(
      path: '/api-config',
      name: 'api-config',
      builder: (context, state) => const ApiConfigurationPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const DistraLoginPage(),
    ),
    GoRoute(
      path: '/treeview',
      name: 'treeview',
      builder: (context, state) => const TreeViewPage(),
    ),
    GoRoute(
      path: '/verification',
      name: 'verification',
      builder: (context, state) => const VerificationPage(),
    ),
    GoRoute(
      path: '/assets',
      name: 'assets',
      builder: (context, state) => const AssetsPage(),
    ),

    GoRoute(
      path: '/responsible',
      name: 'responsible',
      builder: (context, state) => const ResponsablePage(),
    ),
    GoRoute(
      path: '/tools',
      name: 'tools',
      builder: (context, state) => const ToolsPage(),
    ),
    GoRoute(
      path: '/configuration',
      name: 'configuration',
      builder: (context, state) => const ConfigurationPage(),
    ),
    GoRoute(
      path: '/responsabilidad',
      name: 'areas de responsabilidad',
      builder: (context, state) => const AreasDeResponsabilidadPage(),
    ),
  ],
);

class InitialPage extends ConsumerWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isApiConfigured = ref.watch(isApiConfiguredProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isAuthenticated) {
        context.go('/verification');
      } else if (isApiConfigured) {
        context.go('/login');
      } else {
        context.go('/api-config');
      }
    });

    return const Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF1E3A8A)),
            SizedBox(height: 16),
            Text(
              'Cargando DSiMCAF...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF374151),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
