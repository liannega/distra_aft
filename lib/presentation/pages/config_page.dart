import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final backgroundColor = Colors.grey[100];

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.blue, size: 28),
          onPressed: () => context.go('/verification'),
        ),
        title: Text(
          'Configuración',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            SizedBox(height: 20),
            // Sección Red
            Text(
              'Red',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            _buildConfigItem(
              icon: Icons.download,
              iconColor: Colors.orange,
              title: 'Actualizar BD desde el servidor',
              onTap: () {},
            ),
            SizedBox(height: 16),
            _buildConfigItem(
              icon: Icons.refresh,
              iconColor: Colors.orange,
              title: 'Comprobar actualizaciones',
              onTap: () {},
            ),
            SizedBox(height: 40),
         
            Text(
              'Generales',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            _buildConfigItem(
              icon: Icons.file_download,
              iconColor: Colors.orange,
              title: 'Importar datos desde el dispositivo (CSV)',
              onTap: () {},
            ),
            SizedBox(height: 16),
            _buildConfigItem(
              icon: Icons.warning,
              iconColor: Colors.orange,
              title: 'Registro de cambios',
              onTap: () {},
            ),
            SizedBox(height: 16),
            _buildConfigItem(
              icon: Icons.info,
              iconColor: Colors.orange,
              title: 'Acerca de..',
              onTap: () {},
            ),
            SizedBox(height: 16),
            _buildConfigItem(
              icon: Icons.share,
              iconColor: Colors.orange,
              title: 'Compartir aplicación',
              onTap: () {},
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
          ],
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
        padding: EdgeInsets.symmetric(vertical: 5),
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
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
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
