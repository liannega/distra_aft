import 'package:flutter/material.dart';
import 'custom_count_modal.dart';

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

  void _showCustomCountModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => CustomCountModal(onClose: () => Navigator.pop(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      VerificationOption(
        title: 'Nuevo conteo general',
        backgroundColor: const Color(0xFFE8F5E8), // AppTheme.areaCardColor
        icon: Image.asset('assets/images/verification.png', height: 55),
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Función: Conteo General - En desarrollo'),
              backgroundColor: Colors.blue,
            ),
          );
        },
      ),

      VerificationOption(
        title: 'Nuevo conteo parcial mensual',
        backgroundColor: const Color(
          0xFFE3F2FD,
        ), // AppTheme.responsibleCardColor
        icon: Image.asset('assets/images/buscar.png', height: 55),
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Función: Conteo Parcial Mensual - En desarrollo'),
              backgroundColor: Colors.orange,
            ),
          );
        },
      ),

      VerificationOption(
        title: 'Nuevo conteo parcial por:',
        backgroundColor: const Color(0xFFF3E5F5),
        icon: Image.asset('assets/images/note.png', height: 55),
        onTap: () {
          Navigator.pop(context);
          // Mostrar el modal personalizado
          _showCustomCountModal(context);
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
              padding: const EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Adicionar conteo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 24),
                    onPressed: onClose,
                  ),
                ],
              ),
            ),

            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.normal,
                ),
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
