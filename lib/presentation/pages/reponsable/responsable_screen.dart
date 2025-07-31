// ignore_for_file: deprecated_member_use

import 'package:dsimcaf_1/config/utils/custom_context.dart';
import 'package:dsimcaf_1/presentation/shared/app_drawer.dart';
import 'package:dsimcaf_1/presentation/shared/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResponsablesPage extends StatefulWidget {
  const ResponsablesPage({super.key});

  @override
  State<ResponsablesPage> createState() => _ResponsablesPageState();
}

class _ResponsablesPageState extends State<ResponsablesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int _totalResponsables = 214;
  String _searchQuery = '';

  // Datos simulados de responsables
  final List<Map<String, dynamic>> _responsablesList = [
    {
      'id': 'resp_001',
      'nombre': 'Yoendrys Angel Ugando Lavin',
      'cantidadAFT': 45,
      'cantidadUH': 12,
      'cargo': 'Jefe de Área',
      'areas': ['AIRES ACONDICIONADOS INSTALACIONES', 'MANTENIMIENTO GENERAL'],
    },
    {
      'id': 'resp_002',
      'nombre': 'Vidalina Virgen Orozco Rodríguez',
      'cantidadAFT': 120,
      'cantidadUH': 25,
      'cargo': 'Supervisora de Infraestructura',
      'areas': ['TEATRO ZONA 5 INFRAESTRUCTURA'],
    },
    {
      'id': 'resp_003',
      'nombre': 'Maritza Sotto Oduardo',
      'cantidadAFT': 26,
      'cantidadUH': 8,
      'cargo': 'Especialista Técnico',
      'areas': ['OFICINA DE ESPECIALISTAS TÉCNICOS'],
    },
    {
      'id': 'resp_004',
      'nombre': 'Carlos Mendoza Pérez',
      'cantidadAFT': 15,
      'cantidadUH': 35,
      'cargo': 'Jefe de Laboratorio',
      'areas': ['LABORATORIO DE ANÁLISIS QUÍMICO'],
    },
  ];

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
    });
  }

  List<Map<String, dynamic>> get _filteredResponsables {
    return _responsablesList.where((responsable) {
      if (_searchQuery.isEmpty) return true;
      return responsable['nombre'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          responsable['cargo'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredResponsables = _filteredResponsables;
    final filteredCount = filteredResponsables.length;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.go('/verification');
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: context.background,
        appBar: SearchAppBar(
          title: 'Responsables',
          onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
          onSearch: _handleSearch,
          onSearchClear: _clearSearch,
          hasDrawer: true,
        ),
        drawer: const AppDrawer(),
        body: Column(
          children: [
            const SizedBox(height: 16),

            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF607D8B),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  _searchQuery.isEmpty
                      ? 'Total de responsables: $_totalResponsables'
                      : 'Mostrando $filteredCount de $_totalResponsables responsables',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Lista de responsables
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredResponsables.length,
                itemBuilder: (context, index) {
                  final responsable = filteredResponsables[index];
                  return _buildResponsableCard(responsable);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsableCard(Map<String, dynamic> responsable) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: InkWell(
        onTap: () => context.push('/responsible-detail/${responsable['id']}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF607D8B).withOpacity(0.1),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF607D8B),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      responsable['nombre'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      responsable['cargo'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildMediosStat(
                          'AFT',
                          responsable['cantidadAFT'],
                          Colors.blue,
                        ),
                        const SizedBox(width: 16),
                        _buildMediosStat(
                          'UH',
                          responsable['cantidadUH'],
                          Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediosStat(String tipo, int cantidad, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          '$tipo: $cantidad',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
