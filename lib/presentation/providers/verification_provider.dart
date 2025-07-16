import 'package:dsimcaf_1/data/models/verification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Datos simulados
class MockData {
  static List<Area> get areas => [
    const Area(
      id: '1',
      code: '60103',
      name: 'AIRES ACONDICIONADOS INSTALACIONES',
      responsible: 'Yoendrys Angel Ugando Lavin',
      assetsCount: 11,
    ),
    const Area(
      id: '2',
      code: '60102',
      name: 'TEATRO ZONA 5 INFRAESTRUCTURA',
      responsible: 'Vidalina Virgen Orozco Rodríguez',
      assetsCount: 120,
    ),
    const Area(
      id: '3',
      code: '80101',
      name: 'OFICINA DE ESPECIALISTAS TÉCNICOS',
      responsible: 'Maritza Sotto Oduardo',
      assetsCount: 26,
    ),
    const Area(
      id: '4',
      code: '70108',
      name: 'ZONA 3 EQUIPOS DE CLIMA Y REFRIGERACIÓN',
      responsible: 'Jennifer Ramirez Betancourt',
      assetsCount: 40,
    ),
    const Area(
      id: '5',
      code: '50205',
      name: 'LABORATORIO DE ANÁLISIS QUÍMICO',
      responsible: 'Carlos Mendoza Pérez',
      assetsCount: 15,
    ),
    const Area(
      id: '6',
      code: '30401',
      name: 'ALMACÉN GENERAL DE SUMINISTROS',
      responsible: 'Ana María González',
      assetsCount: 85,
    ),
  ];

  static List<Asset> getAssetsForArea(String areaId) {
    switch (areaId) {
      case '1':
        return [
          const Asset(
            id: '1',
            inventoryNumber: '06754',
            description: 'COMPUTADORA DE ESCRITORIO SKYLAND',
            serialNumber: null,
            area: 'AIRES ACONDICIONADOS INSTALACIONES',
            areaResponsible: 'Yoendrys Angel Ugando Lavin',
            assetResponsible: 'Técnico Juan Pérez',
            status: AssetStatus.missing,
          ),
          const Asset(
            id: '2',
            inventoryNumber: '06986',
            description: 'M 21.5 BENQ 1600X900',
            serialNumber: null,
            area: 'AIRES ACONDICIONADOS INSTALACIONES',
            areaResponsible: 'Yoendrys Angel Ugando Lavin',
            assetResponsible: 'Técnico María López',
            status: AssetStatus.missing,
          ),
          const Asset(
            id: '3',
            inventoryNumber: '06987',
            description: 'M 21.5 BENQ 1600X900',
            serialNumber: null,
            area: 'AIRES ACONDICIONADOS INSTALACIONES',
            areaResponsible: 'Yoendrys Angel Ugando Lavin',
            assetResponsible: 'Técnico Carlos Ruiz',
            status: AssetStatus.missing,
          ),
          const Asset(
            id: '4',
            inventoryNumber: '07498',
            description: 'APC BACKUPS ES 10 OUTLET 750VA',
            serialNumber: null,
            area: 'AIRES ACONDICIONADOS INSTALACIONES',
            areaResponsible: 'Yoendrys Angel Ugando Lavin',
            assetResponsible: 'Técnico Ana García',
            status: AssetStatus.missing,
          ),
        ];
      default:
        return [
          Asset(
            id: '${areaId}_1',
            inventoryNumber:
                '0${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
            description:
                'EQUIPO DE ÁREA ${areas.firstWhere((a) => a.id == areaId).code}',
            serialNumber: null,
            area: areas.firstWhere((a) => a.id == areaId).name,
            areaResponsible:
                areas.firstWhere((a) => a.id == areaId).responsible,
            assetResponsible: 'Técnico Asignado',
            status: AssetStatus.missing,
          ),
        ];
    }
  }
}

// Provider para las áreas
final areasProvider = Provider<List<Area>>((ref) => MockData.areas);

// Provider para las verificaciones
class VerificationNotifier extends StateNotifier<List<Verification>> {
  VerificationNotifier() : super([]);

  void createVerification(Area area) {
    final verification = Verification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      areaId: area.id,
      areaName: area.name,
      responsible: area.responsible,
      createdDate: DateTime.now(),
      locationId: '1000015',
      assets: MockData.getAssetsForArea(area.id),
      status: VerificationStatus.inProgress,
    );

    state = [...state, verification];
  }

  void updateAssetStatus(
    String verificationId,
    String assetId,
    AssetStatus newStatus,
  ) {
    state =
        state.map((verification) {
          if (verification.id == verificationId) {
            final updatedAssets =
                verification.assets.map((asset) {
                  if (asset.id == assetId) {
                    return asset.copyWith(status: newStatus);
                  }
                  return asset;
                }).toList();

            return verification.copyWith(assets: updatedAssets);
          }
          return verification;
        }).toList();
  }

  List<Verification> getVerificationsByStatus(VerificationStatus status) {
    return state.where((v) => v.status == status).toList();
  }
}

final verificationProvider =
    StateNotifierProvider<VerificationNotifier, List<Verification>>(
      (ref) => VerificationNotifier(),
    );

// Provider para verificaciones por estado
final inProgressVerificationsProvider = Provider<List<Verification>>((ref) {
  final verifications = ref.watch(verificationProvider);
  return verifications
      .where((v) => v.status == VerificationStatus.inProgress)
      .toList();
});

final plannedVerificationsProvider = Provider<List<Verification>>((ref) {
  final verifications = ref.watch(verificationProvider);
  return verifications
      .where((v) => v.status == VerificationStatus.planned)
      .toList();
});

final completedVerificationsProvider = Provider<List<Verification>>((ref) {
  final verifications = ref.watch(verificationProvider);
  return verifications
      .where((v) => v.status == VerificationStatus.completed)
      .toList();
});
