import 'package:distra_aft/presentation/pages/areas/areas.dart';
import 'package:distra_aft/presentation/pages/assets/assets_page.dart';
import 'package:distra_aft/presentation/pages/configuracion/configuracion_screen.dart';
import 'package:distra_aft/presentation/pages/locations/locations_page.dart';
import 'package:distra_aft/presentation/pages/login_page.dart';
import 'package:distra_aft/presentation/pages/reponsable/responsable_screen.dart';
import 'package:distra_aft/presentation/pages/tools/tools_page.dart';
import 'package:distra_aft/presentation/pages/treeview/treeview.dart';
import 'package:distra_aft/presentation/pages/verificafion/verificacion_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginPage(),
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
      path: '/areas',
      name: 'areas',
      builder: (context, state) => const AreasPage(),
    ),
    GoRoute(
      path: '/locations',
      name: 'locations',
      builder: (context, state) => const LocationsPage(),
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
      builder: (context, state) => const ConfigurationScreen(),
    ),
  ],
);
