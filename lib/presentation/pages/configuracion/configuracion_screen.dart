
import 'package:dsimcaf_1/config/utils/custom_context.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.go('/verification');
        }
      },
      child: Scaffold(
        backgroundColor: context.background,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.primary, size: 28),
            onPressed: () => context.go('/verification'),
          ),
          title: Text(
            'Configuración',
            style: TextStyle(
              color: context.primary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Red',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _buildConfigItem(
                icon: Icons.download,
                iconColor: context.tertiary,
                title: 'Actualizar BD desde el servidor',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _buildConfigItem(
                icon: Icons.refresh,
                iconColor: context.tertiary,
                title: 'Comprobar actualizaciones',
                onTap: () {},
              ),
              const SizedBox(height: 40),
              const Text(
                'Generales',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _buildConfigItem(
                icon: Icons.file_download,
                iconColor: context.tertiary,
                title: 'Importar datos desde el dispositivo (CSV)',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _buildConfigItem(
                icon: Icons.warning,
                iconColor: context.tertiary,
                title: 'Registro de cambios',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _buildConfigItem(
                icon: Icons.info,
                iconColor: context.tertiary,
                title: 'Acerca de..',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _buildConfigItem(
                icon: Icons.share,
                iconColor: context.tertiary,
                title: 'Compartir aplicación',
                onTap: () {},
              ),
              const Spacer(),
              Center(
                child: Text(
                  'DSiMCAF 2',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfigItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
