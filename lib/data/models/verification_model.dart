// Modelos para el sistema de verificaciones
class Area {
  final String id;
  final String code;
  final String name;
  final String responsible;
  final int assetsCount;

  const Area({
    required this.id,
    required this.code,
    required this.name,
    required this.responsible,
    required this.assetsCount,
  });
}

class Asset {
  final String id;
  final String inventoryNumber;
  final String description;
  final String? serialNumber;
  final String area;
  final String areaResponsible;
  final String assetResponsible;
  final AssetStatus status;

  const Asset({
    required this.id,
    required this.inventoryNumber,
    required this.description,
    this.serialNumber,
    required this.area,
    required this.areaResponsible,
    required this.assetResponsible,
    required this.status,
  });

  Asset copyWith({
    String? id,
    String? inventoryNumber,
    String? description,
    String? serialNumber,
    String? area,
    String? areaResponsible,
    String? assetResponsible,
    AssetStatus? status,
  }) {
    return Asset(
      id: id ?? this.id,
      inventoryNumber: inventoryNumber ?? this.inventoryNumber,
      description: description ?? this.description,
      serialNumber: serialNumber ?? this.serialNumber,
      area: area ?? this.area,
      areaResponsible: areaResponsible ?? this.areaResponsible,
      assetResponsible: assetResponsible ?? this.assetResponsible,
      status: status ?? this.status,
    );
  }
}

enum AssetStatus {
  missing, // Faltante
  surplus, // Sobrante
  verified, // Verificado
}

class Verification {
  final String id;
  final String areaId;
  final String areaName;
  final String responsible;
  final DateTime createdDate;
  final String locationId;
  final List<Asset> assets;
  final VerificationStatus status;

  const Verification({
    required this.id,
    required this.areaId,
    required this.areaName,
    required this.responsible,
    required this.createdDate,
    required this.locationId,
    required this.assets,
    required this.status,
  });

  Verification copyWith({
    String? id,
    String? areaId,
    String? areaName,
    String? responsible,
    DateTime? createdDate,
    String? locationId,
    List<Asset>? assets,
    VerificationStatus? status,
  }) {
    return Verification(
      id: id ?? this.id,
      areaId: areaId ?? this.areaId,
      areaName: areaName ?? this.areaName,
      responsible: responsible ?? this.responsible,
      createdDate: createdDate ?? this.createdDate,
      locationId: locationId ?? this.locationId,
      assets: assets ?? this.assets,
      status: status ?? this.status,
    );
  }

  int get missingCount =>
      assets.where((a) => a.status == AssetStatus.missing).length;
  int get surplusCount =>
      assets.where((a) => a.status == AssetStatus.surplus).length;
  int get verifiedCount =>
      assets.where((a) => a.status == AssetStatus.verified).length;
}

enum VerificationStatus {
  inProgress, // En proceso
  planned, // Planificada
  completed, // Terminada
}
