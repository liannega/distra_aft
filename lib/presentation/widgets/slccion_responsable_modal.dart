// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class SeleccionResponsableModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onResponsableSeleccionado;
  final VoidCallback onClose;

  const SeleccionResponsableModal({
    super.key,
    required this.onResponsableSeleccionado,
    required this.onClose,
  });

  @override
  State<SeleccionResponsableModal> createState() =>
      _SeleccionResponsableModalState();
}

class _SeleccionResponsableModalState extends State<SeleccionResponsableModal> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _responsables = [
    {
      'id': '1',
      'name': 'Yoendrys Angel Ugando Lavin',
      'position': 'Jefe de Área',
      'totalAssets': 45,
      'areas': ['AIRES ACONDICIONADOS INSTALACIONES', 'MANTENIMIENTO GENERAL'],
    },
    {
      'id': '2',
      'name': 'Vidalina Virgen Orozco Rodríguez',
      'position': 'Supervisora',
      'totalAssets': 120,
      'areas': ['TEATRO ZONA 5 INFRAESTRUCTURA'],
    },
    {
      'id': '3',
      'name': 'Maritza Sotto Oduardo',
      'position': 'Especialista Técnico',
      'totalAssets': 26,
      'areas': ['OFICINA DE ESPECIALISTAS TÉCNICOS'],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredResponsables =
        _responsables.where((responsable) {
          if (_searchQuery.isEmpty) return true;
          return responsable['name'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              responsable['position'].toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
        }).toList();

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
                children: [
                  IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(Icons.arrow_back, size: 24),
                  ),
                  const Expanded(
                    child: Text(
                      'Seleccionar responsable de área',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar responsable...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 16),

            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredResponsables.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final responsable = filteredResponsables[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap:
                          () => widget.onResponsableSeleccionado(responsable),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              child: const Icon(
                                Icons.person,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    responsable['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    responsable['position'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${responsable['totalAssets']} medios asignados',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
