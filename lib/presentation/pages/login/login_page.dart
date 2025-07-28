import 'package:dsimcaf_1/presentation/providers/user/auth_provider.dart';
import 'package:dsimcaf_1/presentation/providers/user/user_permissions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dsimcaf_1/presentation/providers/api_configuration_provider.dart';

class DistraLoginPage extends ConsumerStatefulWidget {
  const DistraLoginPage({super.key});

  @override
  ConsumerState<DistraLoginPage> createState() => _DistraLoginPageState();
}

class _DistraLoginPageState extends ConsumerState<DistraLoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin({bool isGuest = false}) async {
    if (isGuest) {
      // Usar el sistema de permisos local para invitado
      ref.read(userPermissionsProvider.notifier).setUserFromLogin('invitado');
      context.go('/treeview');
    } else {
      final username = _userController.text.trim();
      final password = _passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        _showError('Por favor ingrese usuario y contraseña');
        return;
      }

      await ref
          .read(authProvider.notifier)
          .login(username: username, password: password);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showAvailableUsers() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Usuarios Disponibles'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: const Text('Usuario DISTRA Real'),
                      subtitle: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Usuario: user1'),
                          Text('Contraseña: PassWord12345'),
                          Text('Tipo: Autenticación API Real'),
                        ],
                      ),
                      onTap: () {
                        _userController.text = 'user1';
                        _passwordController.text = 'PassWord12345';
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  ...PredefinedUsers.users.entries.map((entry) {
                    final username = entry.key;
                    final userInfo = entry.value;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text('${userInfo['name']} (Local)'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Usuario: $username'),
                            Text('Contraseña: ${userInfo['password']}'),
                            Text('Rol: ${userInfo['role']}'),
                          ],
                        ),
                        onTap: () {
                          _userController.text = username;
                          _passwordController.text = userInfo['password']!;
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final apiConfigState = ref.watch(apiConfigurationProvider);

    // Escuchar cambios en el estado de autenticación
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        // Si se autentica con DISTRA, ir directo a verificaciones
        context.go('/verification');
      } else if (next.error != null) {
        _showError(next.error!);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ListView(
            children: [
              const SizedBox(height: 60),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/distra_icon.png",
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'D',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DISTRA AFT',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
                            letterSpacing: 2,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 50),
                          child: Divider(
                            height: 12,
                            endIndent: 25,
                            thickness: 1,
                          ),
                        ),
                        Text(
                          'VERIFICADOR DE ACTIVOS\nFIJOS',
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

              if (apiConfigState.configuration != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green[600],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Conectado a: ${apiConfigState.configuration!.baseUrl}',
                          style: TextStyle(
                            color: Colors.green[800],
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.green[600],
                          size: 16,
                        ),
                        onPressed: () => context.go('/api-config'),
                        tooltip: 'Cambiar configuración',
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 60),
              const Text(
                'Bienvenido(a) de vuelta,',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'ingresa tus datos para continuar',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 64, 87, 122),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 80),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: Colors.grey[800],
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Usuario',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 64, 87, 122),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _userController,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Ingrese el usuario',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF1E3A8A),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.help_outline,
                          color: Colors.grey[600],
                          size: 18,
                        ),
                        onPressed: _showAvailableUsers,
                        tooltip: 'Ver usuarios disponibles',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: Colors.grey[800],
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Contraseña',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color.fromARGB(255, 64, 87, 122),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Ingrese la contraseña',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF1E3A8A),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey[600],
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                          authState.isLoading ? null : () => _handleLogin(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child:
                          authState.isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Acceder',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                          authState.isLoading
                              ? null
                              : () => _handleLogin(isGuest: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child:
                          authState.isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Acceder como invitado',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
