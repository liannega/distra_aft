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
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DSiMCAF 2',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const Text(
                  'Verificador de Activos',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[600],
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Invitado',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Activos fijos
                _buildSectionHeader(context, 'Activos fijos'),
                _buildDrawerItem(
                  context,
                  Icons.verified,
                  'Verificaciones',
                  () => context.go('/verification'),
                ),
                _buildDrawerItem(
                  context,
                  Icons.laptop,
                  'Activos fijos',
                  () => context.go('/assets'),
                ),
                _buildDrawerItem(
                  context,
                  Icons.local_offer,
                  'Áreas',
                  () => context.go('/areas'),
                ),
                _buildDrawerItem(
                  context,
                  Icons.location_on,
                  'Ubicaciones',
                  () => context.go('/locations'),
                ),
                _buildDrawerItem(
                  context,
                  Icons.people,
                  'Responsables',
                  () => context.go('/responsible'),
                ),

                _buildSectionHeader(context, 'Útiles y herramientas'),
                _buildDrawerItem(
                  context,
                  Icons.verified,
                  'Verificaciones',
                  () => context.go('/verification'),
                ),
                _buildDrawerItem(
                  context,
                  Icons.build,
                  'Útiles y herramientas',
                  () => context.go('/tools'),
                ),
                _buildDrawerItem(
                  context,
                  Icons.people,
                  'Responsables',
                  () => context.go('/responsible'),
                ),

                _buildSectionHeader(context, 'Misceláneas'),
                _buildDrawerItem(
                  context,
                  Icons.settings,
                  'Configuración',
                  () => context.go('/configuration'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 24),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
