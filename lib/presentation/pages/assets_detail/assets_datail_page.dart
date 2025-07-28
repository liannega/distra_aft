// ignore_for_file: deprecated_member_use

import 'package:dsimcaf_1/config/utils/custom_context.dart';
import 'package:flutter/material.dart';

class AssetDetailPage extends StatelessWidget {
  final String assetId;
  final String? verificationId;

  const AssetDetailPage({
    super.key,
    required this.assetId,
    this.verificationId,
  });

  @override
  Widget build(BuildContext context) {
    // Datos estáticos del activo
    final asset = {
      'id': assetId,
      'inventoryNumber': '06754',
      'description': 'COMPUTADORA DE ESCRITORIO SKYLAND',
      'serialNumber': 'SKY-2024-001',
      'area': 'AIRES ACONDICIONADOS INSTALACIONES',
      'areaResponsible': 'Yoendrys Angel Ugando Lavin',
      'assetResponsible': 'Técnico Juan Pérez',
      'technicalState': 'Bueno en explotación',
      'acquisitionDate': '2023-05-15',
      'acquisitionValue': '850.00 USD',
      'location': 'Oficina 201, Edificio Principal',
      'brand': 'SKYLAND',
      'model': 'Desktop Pro 2023',
    };

    return Scaffold(
      backgroundColor: context.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detalles del Activo',
          style: TextStyle(
            color: context.primary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (verificationId != null)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
              onPressed: () {
                _showVerificationDialog(context);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta principal del activo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: context.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.laptop,
                          color: context.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              asset['description']!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                asset['inventoryNumber']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Información técnica
            _buildInfoSection(
              'Información Técnica',
              Icons.info_outline,
              Colors.blue,
              [
                _buildInfoItem('Número de Serie', asset['serialNumber']!),
                _buildInfoItem('Marca', asset['brand']!),
                _buildInfoItem('Modelo', asset['model']!),
                _buildInfoItem('Estado Técnico', asset['technicalState']!),
              ],
            ),

            const SizedBox(height: 16),

            // Información de responsabilidad
            _buildInfoSection(
              'Responsabilidad',
              Icons.people_outline,
              Colors.green,
              [
                _buildInfoItem('Área de Responsabilidad', asset['area']!),
                _buildInfoItem(
                  'Responsable del Área',
                  asset['areaResponsible']!,
                ),
                _buildInfoItem('Custodio', asset['assetResponsible']!),
                _buildInfoItem('Ubicación', asset['location']!),
              ],
            ),

            const SizedBox(height: 16),

            // Información financiera
            _buildInfoSection(
              'Información Financiera',
              Icons.attach_money,
              Colors.purple,
              [
                _buildInfoItem(
                  'Fecha de Adquisición',
                  asset['acquisitionDate']!,
                ),
                _buildInfoItem(
                  'Valor de Adquisición',
                  asset['acquisitionValue']!,
                ),
              ],
            ),

            if (verificationId != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _showVerificationDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle),
                  label: const Text(
                    'Verificar Activo',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    String title,
    IconData icon,
    Color color,
    List<Widget> items,
  ) {
    return Container(
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: items),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Verificar Activo'),
              ],
            ),
            content: const Text(
              '¿Confirma que este activo ha sido verificado físicamente?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Activo verificado correctamente'),
                        ],
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Verificar'),
              ),
            ],
          ),
    );
  }
}
