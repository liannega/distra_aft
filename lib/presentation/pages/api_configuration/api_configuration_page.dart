import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dsimcaf_1/presentation/providers/api_configuration_provider.dart';

class ApiConfigurationPage extends ConsumerStatefulWidget {
  const ApiConfigurationPage({super.key});

  @override
  ConsumerState<ApiConfigurationPage> createState() =>
      _ApiConfigurationPageState();
}

class _ApiConfigurationPageState extends ConsumerState<ApiConfigurationPage> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _apiUserController = TextEditingController();
  final TextEditingController _apiPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingConfiguration();
    });
  }

  void _loadExistingConfiguration() {
    final state = ref.read(apiConfigurationProvider);
    if (state.configuration != null) {
      _urlController.text = state.configuration!.baseUrl;
      _apiUserController.text = state.configuration!.apiUsername;
      _apiPasswordController.text = state.configuration!.apiPassword;
    } else {
      _urlController.text = 'https://api.distra.cu/api/';
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _apiUserController.dispose();
    _apiPasswordController.dispose();
    super.dispose();
  }

  void _handleSaveConfiguration() async {
    final baseUrl = _urlController.text.trim();
    final apiUsername = _apiUserController.text.trim();
    final apiPassword = _apiPasswordController.text.trim();

    if (baseUrl.isEmpty || apiUsername.isEmpty || apiPassword.isEmpty) {
      _showError('Todos los campos son obligatorios');
      return;
    }

    if (!Uri.tryParse(baseUrl)!.hasAbsolutePath == true) {
      _showError('URL base no válida');
      return;
    }

    String correctedUrl = baseUrl;
    if (!correctedUrl.endsWith('/')) {
      correctedUrl += '/';
    }

    await ref
        .read(apiConfigurationProvider.notifier)
        .saveConfiguration(
          baseUrl: correctedUrl,
          apiUsername: apiUsername,
          apiPassword: apiPassword,
        );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _fillTestCredentials() {
    _urlController.text = 'https://api.distra.cu/api/';
    _apiUserController.text = 'distra_api';
    _apiPasswordController.text = 'DistraAPI2024';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(apiConfigurationProvider);

    ref.listen<ApiConfigurationState>(apiConfigurationProvider, (
      previous,
      next,
    ) {
      if (previous?.isLoading == true && next.isLoading == false) {
        if (next.error != null) {
          _showError(next.error!);
        } else if (next.configuration != null) {
          context.go('/login');
        }
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: [
              const SizedBox(height: 40),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/distra_icon.png",
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DISTRA AFT',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'CONFIGURACIÓN API DISTRA',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            height: 1.2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 60),

              const Text(
                'Configuración de Acceso',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Configure los datos de acceso al API de DISTRA',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 40),

              _buildInputField(
                controller: _urlController,
                label: 'URL Base del API',
                hint: 'https://api.distra.cu/api/',
                icon: Icons.link,
                keyboardType: TextInputType.url,
              ),

              const SizedBox(height: 24),

              _buildInputField(
                controller: _apiUserController,
                label: 'Usuario del API',
                hint: 'Ingrese el usuario del API',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 24),

              _buildInputField(
                controller: _apiPasswordController,
                label: 'Contraseña del API',
                hint: 'Ingrese la contraseña del API',
                icon: Icons.lock_outline,
                isPassword: true,
              ),

              const SizedBox(height: 40),

              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          state.isLoading ? null : _handleSaveConfiguration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child:
                          state.isLoading
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Guardar Configuración',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: state.isLoading ? null : _fillTestCredentials,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF1E3A8A)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(
                        Icons.help_outline,
                        color: Color(0xFF1E3A8A),
                        size: 20,
                      ),
                      label: const Text(
                        'Usar Credenciales de Prueba',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.security, color: Colors.blue[600], size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Información de Seguridad',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Esta configuración se almacena de forma segura en el dispositivo\n'
                      '• Los datos son cifrados usando AES-256\n'
                      '• Solo se solicita una vez por instalación\n'
                      '• Puede ser modificada desde configuración',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey[700], size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    )
                    : null,
          ),
        ),
      ],
    );
  }
}
