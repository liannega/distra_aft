// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomCountOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  CustomCountOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class CustomCountModal extends StatelessWidget {
  final VoidCallback onClose;

  const CustomCountModal({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final customOptions = [
      CustomCountOption(
        title: 'Área de responsabilidad',
        subtitle: 'Contar por área específica',
        icon: Icons.location_on_outlined,
        color: const Color(0xFF4CAF50),
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Función: Conteo por Área - En desarrollo'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
      CustomCountOption(
        title: 'Responsable de área',
        subtitle: 'Contar por responsable asignado',
        icon: Icons.person_outline,
        color: const Color(0xFF2196F3),
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Función: Conteo por Responsable - En desarrollo'),
              backgroundColor: Colors.blue,
            ),
          );
        },
      ),
      CustomCountOption(
        title: 'Custodio de medio',
        subtitle: 'Contar por custodio específico',
        icon: Icons.security_outlined,
        color: const Color(0xFFFF9800),
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Función: Conteo por Custodio - En desarrollo'),
              backgroundColor: Colors.orange,
            ),
          );
        },
      ),
    ];

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
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

            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                left: 24.0,
                right: 16.0,
                bottom: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nuevo conteo parcial por:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Selecciona el tipo de conteo',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7F8C8D),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 24,
                      color: Color(0xFF7F8C8D),
                    ),
                    onPressed: onClose,
                  ),
                ],
              ),
            ),

            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: customOptions.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                itemBuilder: (context, index) {
                  final option = customOptions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: option.onTap,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFE5E5E5),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: option.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Icon(
                                  option.icon,
                                  color: option.color,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2C3E50),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      option.subtitle,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF7F8C8D),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: option.color,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
