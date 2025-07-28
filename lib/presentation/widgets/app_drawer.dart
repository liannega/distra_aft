// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF8A50), Color(0xFFFF6B35)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo/Título
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'DISTRA AFT',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Verificador de Activos Fijos',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: const Color(0xFFFF6B35),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Invitado',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Modo invitado',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              color: const Color(0xFFFAFAFA),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const SizedBox(height: 8),

                  _buildSectionHeader('Activos fijos', Icons.business_center),
                  _buildDrawerItem(
                    context,
                    Icons.assignment_outlined,
                    'Conteos',
                    const Color(0xFF4CAF50),
                    () => context.go('/verification'),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.laptop_outlined,
                    'Submayor AFT',
                    const Color(0xFF2196F3),
                    () => context.go('/submayor-aft'),
                  ),

                  const SizedBox(height: 8),

                  _buildSectionHeader(
                    'Útiles y herramientas',
                    Icons.build_circle,
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.assignment_outlined,
                    'Conteos',
                    const Color(0xFF4CAF50),
                    () => context.go('/conteos-uh'),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.construction_outlined,
                    'Submayor UH',
                    const Color(0xFFFF9800),
                    () => context.go('/submayor-uh'),
                  ),

                  const SizedBox(height: 8),

                  _buildSectionHeader('Otros', Icons.dashboard),
                  _buildDrawerItem(
                    context,
                    Icons.location_on_outlined,
                    'Áreas de responsabilidad',
                    const Color(0xFF9C27B0),
                    () => context.go('/areas-responsabilidad'),
                  ),
                  _buildDrawerItem(
                    context,
                    Icons.people_outline,
                    'Responsables',
                    const Color(0xFF607D8B),
                    () => context.go('/responsables'),
                  ),

                  const SizedBox(height: 8),

                  _buildSectionHeader('Configuración', Icons.settings),
                  _buildDrawerItem(
                    context,
                    Icons.settings_outlined,
                    'Configuraciones',
                    const Color(0xFF795548),
                    () => context.go('/configuraciones'),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Versión 1.0.0',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const Spacer(),
                Icon(Icons.help_outline, size: 16, color: Colors.grey[600]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF666666)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class AppDrawer extends StatelessWidget {
//   const AppDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Column(
//         children: [
//           Container(
//             height: 200,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFFF8A50), Color(0xFFFF6B35)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Logo/Título
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.2),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Text(
//                         'DISTRA AFT',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           letterSpacing: 1.5,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Verificador de Activos Fijos',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Colors.white70,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const Spacer(),

//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(3),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(25),
//                           ),
//                           child: CircleAvatar(
//                             radius: 22,
//                             backgroundColor: const Color(0xFFFF6B35),
//                             child: const Icon(
//                               Icons.person,
//                               color: Colors.white,
//                               size: 24,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         const Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Invitado',
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Text(
//                                 'Modo invitado',
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.white70,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           Expanded(
//             child: Container(
//               color: const Color(0xFFFAFAFA),
//               child: ListView(
//                 padding: EdgeInsets.zero,
//                 children: [
//                   const SizedBox(height: 8),

//                   _buildSectionHeader('Activos fijos', Icons.business_center),
//                   _buildDrawerItem(
//                     context,
//                     Icons.verified_outlined,
//                     'Conteos',
//                     const Color(0xFF4CAF50),
//                     () => context.go('/verification'),
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     Icons.laptop_outlined,
//                     'Activos fijos',
//                     const Color(0xFF2196F3),
//                     () => context.go('/assets'),
//                   ),

//                   const SizedBox(height: 8),

//                   _buildSectionHeader(
//                     'Útiles y herramientas',
//                     Icons.build_circle,
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     Icons.verified_outlined,
//                     'Conteos',
//                     const Color(0xFF4CAF50),
//                     () => context.go('/verification'),
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     Icons.construction_outlined,
//                     'Útiles y herramientas',
//                     const Color(0xFFFF9800),
//                     () => context.go('/tools'),
//                   ),

//                   const SizedBox(height: 8),

//                   _buildSectionHeader('Generales', Icons.dashboard),
//                   _buildDrawerItem(
//                     context,
//                     Icons.location_on_outlined,
//                     'Áreas de responsabilidad',
//                     const Color(0xFF9C27B0),
//                     () => context.go('/responsabilidad'),
//                   ),
//                   _buildDrawerItem(
//                     context,
//                     Icons.people_outline,
//                     'Responsables',
//                     const Color(0xFF607D8B),
//                     () => context.go('/responsible'),
//                   ),

//                   const SizedBox(height: 8),

//                   _buildSectionHeader('Configuración', Icons.settings),
//                   _buildDrawerItem(
//                     context,
//                     Icons.settings_outlined,
//                     'Configuración',
//                     const Color(0xFF795548),
//                     () => context.go('/configuration'),
//                   ),

//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),

//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(top: BorderSide(color: Colors.grey.shade200)),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Versión 1.0.0',
//                   style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                 ),
//                 const Spacer(),
//                 Icon(Icons.help_outline, size: 16, color: Colors.grey[600]),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title, IconData icon) {
//     return Container(
//       margin: const EdgeInsets.only(top: 8, bottom: 4),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon, size: 18, color: const Color(0xFF666666)),
//           const SizedBox(width: 8),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 13,
//               color: Color(0xFF666666),
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerItem(
//     BuildContext context,
//     IconData icon,
//     String title,
//     Color iconColor,
//     VoidCallback onTap,
//   ) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//             onTap();
//           },
//           borderRadius: BorderRadius.circular(12),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: iconColor.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(icon, color: iconColor, size: 20),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF2C3E50),
//                     ),
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   size: 14,
//                   color: Colors.grey[400],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
