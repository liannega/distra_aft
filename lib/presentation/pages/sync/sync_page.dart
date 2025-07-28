// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SyncPage extends ConsumerStatefulWidget {
  const SyncPage({super.key});

  @override
  ConsumerState<SyncPage> createState() => _SyncPageState();
}

class _SyncPageState extends ConsumerState<SyncPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  bool _isSyncing = false;
  List<SyncStep> _syncSteps = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _initializeSyncSteps();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeSyncSteps() {
    _syncSteps = [
      SyncStep(
        title: 'Validando configuración de integración con el API DISTRA',
        isCompleted: false,
        isInProgress: false,
      ),
      SyncStep(
        title: 'Estableciendo comunicación con DISTRA ERP',
        isCompleted: false,
        isInProgress: false,
      ),
      SyncStep(
        title: 'Sincronizando submayor de AFT',
        isCompleted: false,
        isInProgress: false,
      ),
      SyncStep(
        title: 'Sincronizando submayor de UH',
        isCompleted: false,
        isInProgress: false,
      ),
      SyncStep(
        title:
            'Sincronizando áreas de responsabilidad, responsables y custodios',
        isCompleted: false,
        isInProgress: false,
      ),
      SyncStep(
        title: 'Sincronizando planes de conteos',
        isCompleted: false,
        isInProgress: false,
      ),
    ];
  }

  Future<void> _startSync() async {
    if (!mounted) return;
    setState(() {
      _isSyncing = true;
    });

    _animationController.repeat();

    // Simular proceso de sincronización
    for (int i = 0; i < _syncSteps.length; i++) {
      if (!mounted) return;
      setState(() {
        if (i > 0) {
          _syncSteps[i - 1].isInProgress = false;
          _syncSteps[i - 1].isCompleted = true;
        }
        _syncSteps[i].isInProgress = true;
      });

      await Future.delayed(Duration(milliseconds: 1500 + (i * 200)));
    }
    if (!mounted) return;

    setState(() {
      _syncSteps.last.isInProgress = false;
      _syncSteps.last.isCompleted = true;
      _isSyncing = false;
    });

    _animationController.stop();

    // Mostrar mensaje de éxito
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 12),
                Text('Sincronización Completada'),
              ],
            ),
            content: const Text(
              'Se han sincronizado todos los datos con su personalización de DISTRA ERP.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/verification');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Continuar'),
              ),
            ],
          ),
    );
  }

  void _showSyncConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: const Text(
                    'Confirmar Sincronización',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Esta operación descargará datos del servidor DISTRA ERP.',
                ),
                SizedBox(height: 12),
                Text(
                  'Consumo estimado de datos:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('• Datos móviles: ~15 MB'),
                Text('• WiFi: ~15 MB'),
                SizedBox(height: 12),
                Text(
                  '¿Desea continuar con la sincronización?',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _startSync();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text('Sincronizar'),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C3E50)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Sincronizar Datos',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información de última sincronización
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
                  const Row(
                    children: [
                      Icon(Icons.schedule, color: Color(0xFF3B82F6), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Última Sincronización',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Hace 2 horas (14:30, 15 Ene 2025)',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Exitosa',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Animación de sincronización
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value * 2 * 3.14159,
                      child: const Icon(
                        Icons.sync,
                        size: 80,
                        color: Color(0xFF3B82F6),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Lista de pasos de sincronización
            if (_isSyncing || _syncSteps.any((step) => step.isCompleted)) ...[
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
                    const Text(
                      'Progreso de Sincronización',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._syncSteps.map((step) => _buildSyncStep(step)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Botón de sincronización
            if (!_isSyncing)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _showSyncConfirmation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.sync),
                  label: const Text(
                    'Sincronizar Ahora',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

            if (_isSyncing)
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF64748B),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Sincronizando...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStep(SyncStep step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color:
                  step.isCompleted
                      ? Colors.green
                      : step.isInProgress
                      ? Colors.blue
                      : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                step.isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : step.isInProgress
                    ? const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              step.title,
              style: TextStyle(
                fontSize: 14,
                color:
                    step.isCompleted || step.isInProgress
                        ? const Color(0xFF2C3E50)
                        : Colors.grey,
                fontWeight:
                    step.isInProgress ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SyncStep {
  final String title;
  bool isCompleted;
  bool isInProgress;

  SyncStep({
    required this.title,
    required this.isCompleted,
    required this.isInProgress,
  });
}
