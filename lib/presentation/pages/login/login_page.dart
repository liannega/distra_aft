// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:dsimcaf_1/config/utils/custom_context.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _userController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _userController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: context.background,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 60),
//               // Logo y título
//               Row(
//                 children: [
//                   Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       color: context.secondary,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'D',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 40,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'DSiMCAF 2',
//                         style: TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                           letterSpacing: 2,
//                         ),
//                       ),
//                       Text(
//                         'VERIFICADOR DE ACTIVOS\nFIJOS',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                           height: 1.2,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 80),
//               // Texto de bienvenida
//               const Text(
//                 'Bienvenido(a) de vuelta,',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'ingresa tus datos para continuar',
//                 style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//               ),
//               const SizedBox(height: 60),
//               // Campo Usuario
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.person_outline,
//                         color: Colors.grey[600],
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Usuario',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _userController,
//                     decoration: InputDecoration(
//                       hintText: 'Ingrese el usuario',
//                       hintStyle: TextStyle(color: Colors.grey[400]),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 32),
//               // Campo Contraseña
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.lock_outline,
//                         color: Colors.grey[600],
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'Contraseña',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[700],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _passwordController,
//                     obscureText: _obscurePassword,
//                     decoration: InputDecoration(
//                       hintText: 'Ingrese la contraseña',
//                       hintStyle: TextStyle(color: Colors.grey[400]),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscurePassword
//                               ? Icons.visibility_outlined
//                               : Icons.visibility_off_outlined,
//                           color: Colors.grey[600],
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscurePassword = !_obscurePassword;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               // Botones
//               Column(
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       // IMPORTANTE: Usar GoRouter en lugar de Navigator
//                       onPressed: () {
//                         // Usar GoRouter para navegar al TreeView primero
//                         context.go('/treeview');
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: context.secondary,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Acceder',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: ElevatedButton(
//                       // IMPORTANTE: Usar GoRouter en lugar de Navigator
//                       onPressed: () {
//                         // Usar GoRouter para navegar al TreeView primero
//                         context.go('/treeview');
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF10B981),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Text(
//                         'Acceder como invitado',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
