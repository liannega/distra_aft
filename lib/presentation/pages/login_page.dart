
import 'package:distra_aft/presentation/providers/user/user_permissions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin({bool isGuest = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (isGuest) {
      ref.read(userPermissionsProvider.notifier).setUserFromLogin('invitado');
      context.go('/treeview');
    } else {
      final username = _userController.text.trim();
      final password = _passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        setState(() {
          _errorMessage = 'Por favor ingrese usuario y contraseña';
          _isLoading = false;
        });
        return;
      }

      if (PredefinedUsers.validateUser(username, password)) {
        ref.read(userPermissionsProvider.notifier).setUserFromLogin(username);
        context.go('/treeview');
      } else {
        setState(() {
          _errorMessage = 'Usuario o contraseña incorrectos';
          _isLoading = false;
        });
      }
    }
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
                children:
                    PredefinedUsers.users.entries.map((entry) {
                      final username = entry.key;
                      final userInfo = entry.value;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(userInfo['name']!),
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
                    }).toList(),
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
                  Container(
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
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DSiMCAF 2',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 2),
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
              const SizedBox(height: 60),
              const Text(
                'Bienvenido(a) de vuelta,',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'ingresa tus datos para continuar',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 38, 67, 91),
                  fontWeight: FontWeight.w300,
                ),
              ),

              const SizedBox(height: 150),

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
                          color: Colors.grey[700],
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
                          color: Colors.grey[700],
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

              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[600],
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red[600],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 50),

              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _handleLogin(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      child:
                          _isLoading
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
                                  fontSize:
                                      15,
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
                          _isLoading ? null : () => _handleLogin(isGuest: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      child:
                          _isLoading
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
                                  fontSize:
                                      15,
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
