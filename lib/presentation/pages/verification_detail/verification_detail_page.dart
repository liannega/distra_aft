// ignore_for_file: deprecated_member_use

import 'package:dsimcaf_1/data/models/verification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dsimcaf_1/presentation/providers/verification_provider.dart';
import 'package:dsimcaf_1/config/utils/custom_context.dart';

class VerificationDetailPage extends ConsumerStatefulWidget {
  final String verificationId;

  const VerificationDetailPage({super.key, required this.verificationId});

  @override
  ConsumerState<VerificationDetailPage> createState() =>
      _VerificationDetailPageState();
}

class _VerificationDetailPageState extends ConsumerState<VerificationDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleScanOption(String option) {
    String message = '';
    switch (option) {
      case 'serial':
        message = 'Escanear número de serie';
        break;
      case 'manual':
        message = 'Entrada manual de código';
        break;
      case 'scan':
        message = 'Escaneo de código QR/Barras';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.orange),
    );
  }

  @override
  Widget build(BuildContext context) {
    final verifications = ref.watch(verificationProvider);
    final verification = verifications.firstWhere(
      (v) => v.id == widget.verificationId,
      orElse: () => verifications.first,
    );

    final missingAssets =
        verification.assets
            .where((a) => a.status == AssetStatus.missing)
            .toList();
    final surplusAssets =
        verification.assets
            .where((a) => a.status == AssetStatus.surplus)
            .toList();
    final verifiedAssets =
        verification.assets
            .where((a) => a.status == AssetStatus.verified)
            .toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.primary, size: 24),
          onPressed: () => context.go('/verification'),
        ),
        title: Text(
          'Verificación',
          style: TextStyle(
            color: context.primary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.filter_list,
                color: Colors.white,
                size: 20,
              ),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tabs con contadores
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              indicatorWeight: 3,
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('FALTANTE'),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${verification.missingCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('SOBRANTE'),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${verification.surplusCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('VERIFICA..'),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${verification.verifiedCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Buscador
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filtrar por descripción',
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Contenido de tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAssetsList(missingAssets, verification.id),
                _buildAssetsList(surplusAssets, verification.id),
                _buildAssetsList(verifiedAssets, verification.id),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleScanOption('scan'),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.tune, color: Colors.white),
      ),
    );
  }

  Widget _buildAssetsList(List<Asset> assets, String verificationId) {
    final filteredAssets =
        assets.where((asset) {
          if (_searchQuery.isEmpty) return true;
          return asset.description.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              asset.inventoryNumber.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
        }).toList();

    if (filteredAssets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No se encontraron activos que coincidan con "$_searchQuery"'
                  : 'No hay activos en esta categoría',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredAssets.length,
      itemBuilder: (context, index) {
        final asset = filteredAssets[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              context.push('/asset-detail/${asset.id}/$verificationId');
            },
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          asset.description,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        '${index + 1}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      asset.inventoryNumber,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    asset.serialNumber ?? 'Sin número de serie',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
