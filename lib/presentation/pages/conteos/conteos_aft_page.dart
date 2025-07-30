// ignore_for_file: deprecated_member_use

// import 'package:dsimcaf_1/presentation/providers/nuevos/conteos_provider.dart';
// import 'package:dsimcaf_1/presentation/widgets/new_count_modal.dart';
// import 'package:dsimcaf_1/presentation/widgets/search_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:dsimcaf_1/presentation/widgets/app_drawer.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ConteosPage extends ConsumerStatefulWidget {
//   const ConteosPage({super.key});

//   @override
//   ConsumerState<ConteosPage> createState() => _ConteosPageState();
// }

// class _ConteosPageState extends ConsumerState<ConteosPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   String _searchQuery = '';

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _tabController.index = 1; // "En proceso" por defecto
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _showNuevoConteoModal() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return DraggableScrollableSheet(
//           initialChildSize: 0.8,
//           minChildSize: 0.6,
//           maxChildSize: 0.95,
//           builder: (_, scrollController) {
//             return NuevoConteoModal(
//               tipoMedio: 'AFT',
//               onClose: () => Navigator.pop(context),
//             );
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
//     IconData icon = Icons.info;
//     Color color = Colors.orange;

//     switch (option) {
//       case 'serial':
//         message = 'Función: Escanear número de serie';
//         icon = Icons.qr_code_scanner;
//         color = Colors.blue;
//         break;
//       case 'manual':
//         message = 'Función: Entrada manual de código';
//         icon = Icons.keyboard;
//         color = Colors.green;
//         break;
//       case 'scan':
//         message = 'Función: Escaneo de código QR/Barras';
//         icon = Icons.qr_code;
//         color = Colors.purple;
//         break;
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Icon(icon, color: Colors.white, size: 20),
//             const SizedBox(width: 12),
//             Expanded(child: Text(message)),
//           ],
//         ),
//         backgroundColor: color,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(16),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final conteosEnProceso = ref.watch(conteosEnProcesoProvider);
//     final conteosPlanificados = ref.watch(conteosPlanificadosProvider);
//     final conteosTerminados = ref.watch(conteosTerminadosProvider);

//     return PopScope(
//       canPop: false,
//       onPopInvoked: (didPop) {
//         if (!didPop) {
//           Navigator.of(context).pop();
//         }
//       },
//       child: Scaffold(
//         key: _scaffoldKey,
//         backgroundColor: const Color(0xFFF8FAFC),
//         appBar: SearchAppBar(
//           title: 'Conteos de AFT',
//           onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
//           onSearch: _handleSearch,
//           onSearchClear: _clearSearch,
//           onScanOption: _handleScanOption,
//           hasDrawer: true,
//         ),
//         drawer: const AppDrawer(),
//         body: Column(
//           children: [
//             // Tabs mejorados
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: TabBar(
//                 controller: _tabController,
//                 labelColor: Colors.white,
//                 unselectedLabelColor: const Color(0xFF64748B),
//                 indicator: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFFFF8A50), Color(0xFFFF6B35)],
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 indicatorSize: TabBarIndicatorSize.tab,
//                 dividerColor: Colors.transparent,
//                 labelStyle: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 unselectedLabelStyle: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 tabs: const [
//                   Tab(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       child: Text('Planificados'),
//                     ),
//                   ),
//                   Tab(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       child: Text('En proceso'),
//                     ),
//                   ),
//                   Tab(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                       child: Text('Terminados'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 16),

//             // Content
//             Expanded(
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   _buildConteosTab(
//                     conteosPlanificados,
//                     'Planificados',
//                     Icons.schedule,
//                     const Color(0xFF8B5CF6),
//                   ),
//                   _buildConteosTab(
//                     conteosEnProceso,
//                     'En proceso',
//                     Icons.hourglass_empty,
//                     const Color(0xFF3B82F6),
//                   ),
//                   _buildConteosTab(
//                     conteosTerminados,
//                     'Terminados',
//                     Icons.check_circle,
//                     const Color(0xFF10B981),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           onPressed: _showNuevoConteoModal,
//           backgroundColor: const Color(0xFFFF6B35),
//           foregroundColor: Colors.white,
//           icon: const Icon(Icons.add),
//           label: const Text(
//             'Adicionar conteo',
//             style: TextStyle(fontWeight: FontWeight.w600),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildConteosTab(
//     List<dynamic> conteos,
//     String tabName,
//     IconData tabIcon,
//     Color accentColor,
//   ) {
//     final filteredConteos =
//         conteos.where((conteo) {
//           if (_searchQuery.isEmpty) return true;
//           return conteo['tipo'].toLowerCase().contains(
//                 _searchQuery.toLowerCase(),
//               ) ||
//               conteo['area'].toLowerCase().contains(_searchQuery.toLowerCase());
//         }).toList();

//     if (filteredConteos.isEmpty) {
//       return _buildEmptyState(tabName, tabIcon, accentColor);
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: filteredConteos.length,
//       itemBuilder: (context, index) {
//         final conteo = filteredConteos[index];
//         return _buildConteoCard(conteo);
//       },
//     );
//   }

//   Widget _buildConteoCard(Map<String, dynamic> conteo) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: InkWell(
//         onTap: () {
//           // Navegar a detalles del conteo
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Ver detalles del conteo: ${conteo['tipo']}'),
//               backgroundColor: Colors.blue,
//             ),
//           );
//         },
//         borderRadius: BorderRadius.circular(16),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: _getTipoColor(conteo['tipo']),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       conteo['tipo'],
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   const Spacer(),
//                   Text(
//                     conteo['fecha'],
//                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 conteo['area'],
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               if (conteo['responsable'] != null) ...[
//                 const SizedBox(height: 4),
//                 Text(
//                   conteo['responsable'],
//                   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                 ),
//               ],
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildEstadisticaItem(
//                       'Total',
//                       conteo['total'].toString(),
//                       Colors.blue,
//                     ),
//                   ),
//                   if (conteo['verificados'] != null) ...[
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _buildEstadisticaItem(
//                         'Verificados',
//                         conteo['verificados'].toString(),
//                         Colors.green,
//                       ),
//                     ),
//                   ],
//                   if (conteo['faltantes'] != null) ...[
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _buildEstadisticaItem(
//                         'Faltantes',
//                         conteo['faltantes'].toString(),
//                         Colors.red,
//                       ),
//                     ),
//                   ],
//                   if (conteo['sobrantes'] != null) ...[
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _buildEstadisticaItem(
//                         'Sobrantes',
//                         conteo['sobrantes'].toString(),
//                         Colors.orange,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEstadisticaItem(String label, String value, Color color) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//       ],
//     );
//   }

//   Color _getTipoColor(String tipo) {
//     switch (tipo.toLowerCase()) {
//       case 'general':
//         return Colors.purple;
//       case 'parcial mensual':
//         return Colors.blue;
//       case 'personalizado':
//         return Colors.green;
//       default:
//         return Colors.grey;
//     }
//   }

//   Widget _buildEmptyState(String tabName, IconData tabIcon, Color accentColor) {
//     return Container(
//       margin: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 280,
//             height: 280,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(24),
//                       gradient: LinearGradient(
//                         colors: [
//                           accentColor.withOpacity(0.05),
//                           accentColor.withOpacity(0.02),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 80,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           color: accentColor.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Icon(tabIcon, size: 40, color: accentColor),
//                       ),
//                       const SizedBox(height: 20),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.asset(
//                           'assets/images/nose.png',
//                           width: 120,
//                           height: 120,
//                           fit: BoxFit.contain,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Container(
//                               width: 120,
//                               height: 120,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFF1F5F9),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.search_off,
//                                     size: 40,
//                                     color: Colors.grey[400],
//                                   ),
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     _searchQuery.isNotEmpty
//                                         ? 'Sin resultados'
//                                         : 'Sin datos',
//                                     style: TextStyle(
//                                       color: Colors.grey[500],
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 32),

//           Text(
//             _searchQuery.isNotEmpty
//                 ? 'Sin resultados para "$_searchQuery"'
//                 : 'No hay conteos $tabName',
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1E293B),
//             ),
//           ),

//           const SizedBox(height: 12),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               _searchQuery.isNotEmpty
//                   ? 'Intenta con otros términos de búsqueda o revisa la ortografía'
//                   : _getEmptyStateDescription(tabName),
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Color(0xFF64748B),
//                 height: 1.5,
//               ),
//             ),
//           ),

//           const SizedBox(height: 32),

//           if (_searchQuery.isEmpty)
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: accentColor.withOpacity(0.2),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: ElevatedButton.icon(
//                 onPressed: _showNuevoConteoModal,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: accentColor,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 24,
//                     vertical: 16,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   elevation: 0,
//                 ),
//                 icon: const Icon(Icons.add, size: 20),
//                 label: const Text(
//                   'Adicionar conteo',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   String _getEmptyStateDescription(String tabName) {
//     switch (tabName) {
//       case 'Planificados':
//         return 'Los conteos programados para fechas futuras se mostrarán en esta sección.';
//       case 'En proceso':
//         return 'Cuando inicies un conteo, aparecerá aquí para que puedas continuar trabajando en él.';
//       case 'Terminados':
//         return 'Aquí encontrarás el historial de todos los conteos completados exitosamente.';
//       default:
//         return 'Comienza creando tu primer conteo para ver el contenido aquí.';
//     }
//   }
// }
