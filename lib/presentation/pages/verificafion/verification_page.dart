// ignore_for_file: deprecated_member_use

import 'package:dsimcaf_1/presentation/widgets/search_dialog.dart';
import 'package:dsimcaf_1/presentation/widgets/verification_modal.dart';
import 'package:flutter/material.dart';
import 'package:dsimcaf_1/presentation/widgets/app_drawer.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showVerificationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return VerificationModal(onClose: () => Navigator.pop(context));
          },
        );
      },
    );
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
    });
  }

  void _handleScanOption(String option) {
    String message = '';
    IconData icon = Icons.info;
    Color color = Colors.orange;

    switch (option) {
      case 'serial':
        message = 'Función: Escanear número de serie';
        icon = Icons.qr_code_scanner;
        color = Colors.blue;
        break;
      case 'manual':
        message = 'Función: Entrada manual de código';
        icon = Icons.keyboard;
        color = Colors.green;
        break;
      case 'scan':
        message = 'Función: Escaneo de código QR/Barras';
        icon = Icons.qr_code;
        color = Colors.purple;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: SearchAppBar(
        title: 'Verificaciones',
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        onSearch: _handleSearch,
        onSearchClear: _clearSearch,
        onScanOption: _handleScanOption,
        hasDrawer: true,
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // Tabs mejorados
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xFF64748B),
              indicator: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8A50), Color(0xFFFF6B35)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('En proceso'),
                  ),
                ),
                Tab(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Planificadas'),
                  ),
                ),
                Tab(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Terminadas'),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmptyState(
                  'En proceso',
                  Icons.hourglass_empty,
                  const Color(0xFF3B82F6),
                ),
                _buildEmptyState(
                  'Planificadas',
                  Icons.schedule,
                  const Color(0xFF8B5CF6),
                ),
                _buildEmptyState(
                  'Terminadas',
                  Icons.check_circle,
                  const Color(0xFF10B981),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String tabName, IconData tabIcon, Color accentColor) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Contenedor de ilustración mejorado
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Patrón de fondo sutil
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withOpacity(0.05),
                          accentColor.withOpacity(0.02),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                // Contenido
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icono principal
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(tabIcon, size: 40, color: accentColor),
                      ),
                      const SizedBox(height: 20),
                      // Imagen o placeholder
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/nose.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _searchQuery.isNotEmpty
                                        ? 'Sin resultados'
                                        : 'Sin datos',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Título principal
          Text(
            _searchQuery.isNotEmpty
                ? 'Sin resultados para "$_searchQuery"'
                : 'No hay verificaciones $tabName',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),

          const SizedBox(height: 12),

          // Descripción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _searchQuery.isNotEmpty
                  ? 'Intenta con otros términos de búsqueda o revisa la ortografía'
                  : _getEmptyStateDescription(tabName),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Botón de acción (solo si no hay búsqueda)
          if (_searchQuery.isEmpty)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: _showVerificationModal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.add, size: 20),
                label: const Text(
                  'Crear nueva verificación',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getEmptyStateDescription(String tabName) {
    switch (tabName) {
      case 'En proceso':
        return 'Cuando inicies una verificación, aparecerá aquí para que puedas continuar trabajando en ella.';
      case 'Planificadas':
        return 'Las verificaciones programadas para fechas futuras se mostrarán en esta sección.';
      case 'Terminadas':
        return 'Aquí encontrarás el historial de todas las verificaciones completadas exitosamente.';
      default:
        return 'Comienza creando tu primera verificación para ver el contenido aquí.';
    }
  }
}
// import 'package:dsimcaf_1/presentation/widgets/search_dialog.dart';
// import 'package:dsimcaf_1/presentation/widgets/verification_modal.dart';
// import 'package:flutter/material.dart';
// import 'package:dsimcaf_1/presentation/widgets/app_drawer.dart';
// import 'package:dsimcaf_1/config/utils/custom_context.dart';

// class VerificationPage extends StatefulWidget {
//   const VerificationPage({super.key});

//   @override
//   State<VerificationPage> createState() => _VerificationPageState();
// }

// class _VerificationPageState extends State<VerificationPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _showVerificationModal() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.7,
//           minChildSize: 0.5,
//           maxChildSize: 0.95,
//           builder: (_, scrollController) {
//             return VerificationModal(onClose: () => Navigator.pop(context));
//           },
//         );
//       },
//     );
//   }

//   void _handleSearch(String query) {
//     setState(() {
//       _searchQuery = query;
//     });
//   }

//   void _clearSearch() {
//     setState(() {
//       _searchQuery = '';
//     });
//   }

//   void _handleScanOption(String option) {
//     String message = '';
//     switch (option) {
//       case 'serial':
//         message = 'Función: Escanear número de serie';
//         break;
//       case 'manual':
//         message = 'Función: Entrada manual de código';
//         break;
//       case 'scan':
//         message = 'Función: Escaneo de código QR/Barras';
//         break;
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.orange,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: context.background,
//       appBar: SearchAppBar(
//         title: 'Verificaciones',
//         onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
//         onSearch: _handleSearch,
//         onSearchClear: _clearSearch,
//         onScanOption: _handleScanOption,
//         hasDrawer: true,
//       ),
//       drawer: const AppDrawer(),
//       body: Column(
//         children: [
//           // Tabs
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             child: TabBar(
//               controller: _tabController,
//               labelColor: Colors.orange,
//               unselectedLabelColor: Colors.grey[400],
//               indicatorColor: Colors.orange,
//               indicatorWeight: 3,
//               labelStyle: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w800,
//               ),
//               unselectedLabelStyle: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w800,
//               ),
//               tabs: const [
//                 Tab(text: 'En proceso'),
//                 Tab(text: 'Planificadas'),
//                 Tab(text: 'Terminadas'),
//               ],
//             ),
//           ),
//           // Content
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildEmptyState(),
//                 _buildEmptyState(),
//                 _buildEmptyState(),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showVerificationModal,
//         backgroundColor: Colors.orange,
//         child: const Icon(Icons.add, color: Colors.white, size: 28),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Ilustración
//           SizedBox(
//             width: 200,
//             height: 200,
//             child: Image.asset(
//               'assets/images/nose.png',
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   width: 200,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.search, size: 60, color: Colors.grey[400]),
//                       const SizedBox(height: 16),
//                       Text(
//                         _searchQuery.isNotEmpty
//                             ? 'Sin resultados\npara "$_searchQuery"'
//                             : 'Ilustración\nno encontrada',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.grey[500], fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 32),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Text(
//               _searchQuery.isNotEmpty
//                   ? 'No se encontraron verificaciones que coincidan con "$_searchQuery"'
//                   : 'Usted no tiene verificaciones, por favor inicie una nueva',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 18,
//                 color: context.primary,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:dsimcaf_1/presentation/widgets/search_dialog.dart';
// import 'package:dsimcaf_1/presentation/widgets/verification_modal.dart';
// import 'package:flutter/material.dart';
// import 'package:dsimcaf_1/presentation/widgets/app_drawer.dart';
// import 'package:dsimcaf_1/config/utils/custom_context.dart';

// class VerificationPage extends StatefulWidget {
//   const VerificationPage({super.key});

//   @override
//   State<VerificationPage> createState() => _VerificationPageState();
// }

// class _VerificationPageState extends State<VerificationPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _showVerificationModal() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.7,
//           minChildSize: 0.5,
//           maxChildSize: 0.95,
//           builder: (_, scrollController) {
//             return VerificationModal(onClose: () => Navigator.pop(context));
//           },
//         );
//       },
//     );
//   }

//   void _handleSearch(String query) {
//     setState(() {
//       _searchQuery = query;
//     });
//   }

//   void _clearSearch() {
//     setState(() {
//       _searchQuery = '';
//     });
//   }

//   void _handleScanOption(String option) {
//     String message = '';
//     switch (option) {
//       case 'serial':
//         message = 'Función: Escanear número de serie';
//         break;
//       case 'manual':
//         message = 'Función: Entrada manual de código';
//         break;
//       case 'scan':
//         message = 'Función: Escaneo de código QR/Barras';
//         break;
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.orange,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: context.background,
//       appBar: SearchAppBar(
//         title: 'Verificaciones',
//         onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
//         onSearch: _handleSearch,
//         onSearchClear: _clearSearch,
//         onScanOption: _handleScanOption,
//         hasDrawer: true,
//       ),
//       drawer: const AppDrawer(),
//       body: Column(
//         children: [
//           // Tabs
//           Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16),
//             child: TabBar(
//               controller: _tabController,
//               labelColor: Colors.orange,
//               unselectedLabelColor: Colors.grey[400],
//               indicatorColor: Colors.orange,
//               indicatorWeight: 3,
//               labelStyle: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w800,
//               ),
//               unselectedLabelStyle: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w800,
//               ),
//               tabs: const [
//                 Tab(text: 'En proceso'),
//                 Tab(text: 'Planificadas'),
//                 Tab(text: 'Terminadas'),
//               ],
//             ),
//           ),
//           // Content
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildEmptyState(),
//                 _buildEmptyState(),
//                 _buildEmptyState(),
//               ],
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showVerificationModal,
//         backgroundColor: Colors.orange,
//         child: const Icon(Icons.add, color: Colors.white, size: 28),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Ilustración
//           SizedBox(
//             width: 200,
//             height: 200,
//             child: Image.asset(
//               'assets/images/nose.png',
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   width: 200,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.search, size: 60, color: Colors.grey[400]),
//                       const SizedBox(height: 16),
//                       Text(
//                         _searchQuery.isNotEmpty
//                             ? 'Sin resultados\npara "$_searchQuery"'
//                             : 'Ilustración\nno encontrada',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.grey[500], fontSize: 14),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 32),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Text(
//               _searchQuery.isNotEmpty
//                   ? 'No se encontraron verificaciones que coincidan con "$_searchQuery"'
//                   : 'Usted no tiene verificaciones, por favor inicie una nueva',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 18,
//                 color: context.primary,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
