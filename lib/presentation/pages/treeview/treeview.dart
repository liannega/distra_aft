
import 'package:distra_aft/config/utils/custom_context.dart';
import 'package:distra_aft/presentation/providers/user/user_permissions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TreeViewPage extends ConsumerStatefulWidget {
  const TreeViewPage({super.key});

  @override
  ConsumerState<TreeViewPage> createState() => _TreeViewPageState();
}

class _TreeViewPageState extends ConsumerState<TreeViewPage> {
  final Map<String, bool> _expandedNodes = {
    'dominio_entidades': false,
    'empresa_servicios': false,
    'agencias': false,
  };

  void _toggleNode(String nodeKey) {
    setState(() {
      _expandedNodes[nodeKey] = !(_expandedNodes[nodeKey] ?? false);
    });
  }

  void _handleAccept() {
    context.go('/verification');
  }

  @override
  Widget build(BuildContext context) {
    final userPermissions = ref.watch(userPermissionsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [context.primary, context.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/'),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Sistema de Gestión Integral de Seguridad',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (userPermissions != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userPermissions.userName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Entidad: ${userPermissions.selectedEntity}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
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
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_tree,
                            color: context.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Seleccione su dominio de trabajo',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [_buildTreeStructure()],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      'Continuar al Sistema',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreeStructure() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTreeNode(
          title: 'Dominio de entidades',
          moduleKey: 'dominio_entidades',
          level: 0,
          hasChildren: true,
          onTap: () => _toggleNode('dominio_entidades'),
        ),

        if (_expandedNodes['dominio_entidades'] == true) ...[
          _buildTreeNode(
            title: 'Empresa de Servicios Automotores SA',
            moduleKey: 'empresa_servicios',
            level: 1,
            hasChildren: true,
            onTap: () => _toggleNode('empresa_servicios'),
          ),

          if (_expandedNodes['empresa_servicios'] == true) ...[
            _buildTreeNode(
              title: 'CASA MATRIZ',
              moduleKey: 'casa_matriz',
              level: 2,
              hasChildren: false,
            ),
            _buildTreeNode(
              title: 'AGENCIAS',
              moduleKey: 'agencias',
              level: 2,
              hasChildren: true,
              onTap: () => _toggleNode('agencias'),
            ),

            if (_expandedNodes['agencias'] == true) ...[
              _buildTreeNode(
                title: 'AGENCIA LA PALMA',
                moduleKey: 'agencia_la_palma',
                level: 3,
                hasChildren: false,
              ),
              _buildTreeNode(
                title: 'AGENCIA HABANA DEL ESTE',
                moduleKey: 'agencia_habana_este',
                level: 3,
                hasChildren: false,
              ),
              _buildTreeNode(
                title: 'AGENCIA MATANZAS',
                moduleKey: 'agencia_matanzas',
                level: 3,
                hasChildren: false,
              ),
              _buildTreeNode(
                title: 'AGENCIA VARADERO',
                moduleKey: 'agencia_varadero',
                level: 3,
                hasChildren: false,
              ),
              _buildTreeNode(
                title: 'AGENCIA VILLA CLARA',
                moduleKey: 'agencia_villa_clara',
                level: 3,
                hasChildren: false,
              ),
              _buildTreeNode(
                title: 'AGENCIA CAMAGUEY',
                moduleKey: 'agencia_camaguey',
                level: 3,
                hasChildren: false,
              ),
              _buildTreeNode(
                title: 'AGENCIA SANTIAGO DE CUBA',
                moduleKey: 'agencia_santiago',
                level: 3,
                hasChildren: false,
              ),
            ],
          ],
        ],
      ],
    );
  }

  Widget _buildTreeNode({
    required String title,
    required String moduleKey,
    required int level,
    required bool hasChildren,
    VoidCallback? onTap,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        final hasPermission = ref.watch(modulePermissionProvider(moduleKey));
        final isExpanded = _expandedNodes[moduleKey] ?? false;

        Color textColor = hasPermission ? Colors.green[700]! : Colors.black54;
        Color iconColor =
            hasPermission ? Colors.green[600]! : Colors.grey[600]!;

        return InkWell(
          onTap: hasChildren ? onTap : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.only(
              left: (level * 24.0) + 8,
              top: 8,
              bottom: 8,
              right: 8,
            ),
            child: Row(
              children: [
                if (hasChildren) ...[
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isExpanded ? '−' : '+',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: iconColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ] else ...[
                  const SizedBox(width: 28),
                ],
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    hasChildren
                        ? (hasPermission ? Icons.folder : Icons.folder_outlined)
                        : (hasPermission
                            ? Icons.location_city
                            : Icons.location_city_outlined),
                    size: 18,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      color: textColor,
                      fontWeight:
                          title.contains('Empresa') || title.contains('Dominio')
                              ? FontWeight.bold
                              : FontWeight.w500,
                    ),
                  ),
                ),
                if (hasPermission)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
