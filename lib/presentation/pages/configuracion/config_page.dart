// ignore_for_file: deprecated_member_use

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:dsimcaf_1/presentation/shared/app_drawer.dart';

class ConfiguracionesPage extends StatefulWidget {
  const ConfiguracionesPage({super.key});

  @override
  State<ConfiguracionesPage> createState() => _ConfiguracionesPageState();
}

class _ConfiguracionesPageState extends State<ConfiguracionesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isUpdating = false;
  bool _isConnecting = false;

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
        key: _scaffoldKey,
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFFFF6B35), size: 28),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          title: const Text(
            'Configuraciones',
            style: TextStyle(
              color: Color(0xFF2C3E50),
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: Colors.grey.shade200),
          ),
        ),
        drawer: const AppDrawer(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // Sección Red
              _buildSectionHeader('Red', Icons.wifi, const Color(0xFF3B82F6)),
              const SizedBox(height: 16),

              _buildConfigCard([
                _buildConfigItem(
                  icon: Icons.cloud_download_outlined,
                  iconColor: const Color(0xFF10B981),
                  title:
                      'Sincronizar datos locales con el servidor de DISTRA ERP',
                  subtitle: 'Actualizar BD desde el servidor',
                  isLoading: _isUpdating,
                  onTap: _handleUpdateDatabase,
                ),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                _buildConfigItem(
                  icon: Icons.settings_ethernet_outlined,
                  iconColor: const Color(0xFF8B5CF6),
                  title: 'Configuración de integración con el API DISTRA',
                  subtitle: 'Configurar endpoint y credenciales',
                  isLoading: _isConnecting,
                  onTap: _handleConfigureAPI,
                ),
              ]),

              const SizedBox(height: 32),

              _buildSectionHeader(
                'Aplicación',
                Icons.tune,
                const Color(0xFFFF6B35),
              ),
              const SizedBox(height: 16),

              _buildConfigCard([
                _buildConfigItem(
                  icon: Icons.info_outline,
                  iconColor: const Color(0xFF06B6D4),
                  title: 'Acerca de',
                  subtitle: 'Información de la aplicación',
                  onTap: _showAboutDialog,
                ),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                _buildConfigItem(
                  icon: Icons.share_outlined,
                  iconColor: const Color(0xFFEC4899),
                  title: 'Compartir aplicación',
                  subtitle: 'Invitar a otros usuarios',
                  onTap: _shareApplication,
                ),
              ]),

              const SizedBox(height: 40),

              // Footer
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF8A50), Color(0xFFFF6B35)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        'DISTRA AFT',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Versión 0.1',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }

  Widget _buildConfigCard(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildConfigItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    isLoading
                        ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              iconColor,
                            ),
                          ),
                        )
                        : Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  // Funciones de manejo de eventos
  void _handleUpdateDatabase() async {
    setState(() {
      _isUpdating = true;
    });

    // Navegar a la página de sincronización
    context.push('/sync');

    setState(() {
      _isUpdating = false;
    });
  }

  void _handleConfigureAPI() async {
    setState(() {
      _isConnecting = true;
    });

    // Navegar a configuración de API
    context.push('/api-config');

    setState(() {
      _isConnecting = false;
    });
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => ZoomIn(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF8A50), Color(0xFFFF6B35)],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('DISTRA AFT'),
                ],
              ),
              content: const SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Versión: v0.1',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Aplicación móvil offline-first que permite realizar conteos físicos de activos fijos tangibles (AFT), sincronizando posteriormente los datos con el sistema DISTRA ERP, mejorando la eficiencia, precisión y trazabilidad del proceso.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Funcionalidades:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Autenticación de usuarios según protocolos de autenticación de API DISTRA y DISTRA ERP',
                    ),
                    Text(
                      '• Descarga de datos para el trabajo offline y sincronización con DISTRA ERP',
                    ),
                    Text(
                      '• Realizar conteos (general, parcial mensual y parcial personalizado) de AFT y UH',
                    ),
                    Text(
                      '• Ajuste directo con las reglas para la gestión de AFT y UH, definidos en DISTRA ERP',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Desarrollado por:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'UB Empresa Digital. Empresa de Tecnologías de la Información para la Defensa (XETID)',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Web: https://www.xetid.cu/es/productos/distra',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ],
            ),
          ),
    );
  }

  void _shareApplication() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(Icons.share, size: 48, color: Color(0xFFEC4899)),
                      SizedBox(height: 16),
                      Text(
                        'Compartir DISTRA AFT',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Comparte el archivo APK con otros usuarios',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildShareOption(
                        icon: Icons.link,
                        title: 'Copiar enlace',
                        subtitle: 'Compartir enlace de descarga',
                        onTap: () {
                          Navigator.pop(context);
                          _copyAppLink();
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildShareOption(
                        icon: Icons.message,
                        title: 'Compartir por mensaje',
                        subtitle: 'Enviar por WhatsApp, SMS, etc.',
                        onTap: () {
                          Navigator.pop(context);
                          _shareViaMessage();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEC4899).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFFEC4899), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyAppLink() {
    const appLink = 'https://xetid.cu/downloads/distra-aft.apk';
    Clipboard.setData(const ClipboardData(text: appLink));
    _showSuccessSnackBar('Enlace copiado al portapapeles');
  }

  void _shareViaMessage() {
    const message = '''
¡Hola! Te invito a usar DISTRA AFT, una aplicación para la gestión y verificación de activos fijos.

Descárgala aquí: https://xetid.cu/downloads/distra-aft.apk

¡Es muy útil para el control de inventarios!
''';

    Clipboard.setData(const ClipboardData(text: message));
    _showSuccessSnackBar(
      'Mensaje copiado. Pégalo en tu app de mensajería favorita',
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
