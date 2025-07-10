
import 'package:dsimcaf_1/config/themes/app_theme.dart';
import 'package:flutter/material.dart';

class VerificationOption {
  final String title;
  final Color backgroundColor;
  final Widget icon;
  final VoidCallback onTap;

  VerificationOption({
    required this.title,
    required this.backgroundColor,
    required this.icon,
    required this.onTap,
  });
}

class VerificationModal extends StatelessWidget {
  final VoidCallback onClose;

  const VerificationModal({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final options = [
      VerificationOption(
        title: 'Nueva verificación por área',
        backgroundColor: AppTheme.areaCardColor,
        icon: Image.asset('assets/images/verification.png', height: 80),
        onTap: () {
          Navigator.pop(context);
          // Implementar acción
        },
      ),
      VerificationOption(
        title: 'Nueva verificación por ubicación',
        backgroundColor: AppTheme.locationCardColor,
        icon: Image.asset(
          'assets/images/verification.png',
          height: 80,
        ),
        onTap: () {
          Navigator.pop(context);
          // Implementar acción
        },
      ),
      VerificationOption(
        title: 'Nueva verificación por responsable',
        backgroundColor: AppTheme.responsibleCardColor,
        icon: Image.asset(
          'assets/images/verification.png',
          height: 80,
        ),
        onTap: () {
          Navigator.pop(context);
          // Implementar acción
        },
      ),
      VerificationOption(
        title: 'Nueva verificación por custodio',
        backgroundColor: AppTheme.custodianCardColor,
        icon: Image.asset(
          'assets/images/verification.png',
          height: 80,
        ),
        onTap: () {
          Navigator.pop(context);
          // Implementar acción
        },
      ),
      VerificationOption(
        title: 'Nueva verificación personalizada',
        backgroundColor: AppTheme.customCardColor,
        icon: Image.asset('assets/images/verification.png', height: 80),
        onTap: () {
          Navigator.pop(context);
          // Implementar acción
        },
      ),
    ];

    return Material(
      color: Colors.transparent,
      child: Container(
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nueva verificación',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: options.length,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  final option = options[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: InkWell(
                      onTap: option.onTap,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: option.backgroundColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            option.icon,
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
