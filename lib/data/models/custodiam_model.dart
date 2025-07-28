import 'dart:convert';

class AssetModel {
  final String id;
  final String inventoryNumber;
  final String description;
  final String? serialNumber;
  final String category;
  final String subcategory;
  final String brand;
  final String model;
  final String status;
  final String condition;
  final double acquisitionValue;
  final DateTime acquisitionDate;
  final String supplier;
  final String location;
  final String areaId;
  final String responsibleId;
  final String custodianId;
  final String? observations;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AssetModel({
    required this.id,
    required this.inventoryNumber,
    required this.description,
    this.serialNumber,
    required this.category,
    required this.subcategory,
    required this.brand,
    required this.model,
    required this.status,
    required this.condition,
    required this.acquisitionValue,
    required this.acquisitionDate,
    required this.supplier,
    required this.location,
    required this.areaId,
    required this.responsibleId,
    required this.custodianId,
    this.observations,
    required this.createdAt,
    required this.updatedAt,
  });

  AssetModel copyWith({
    String? id,
    String? inventoryNumber,
    String? description,
    String? serialNumber,
    String? category,
    String? subcategory,
    String? brand,
    String? model,
    String? status,
    String? condition,
    double? acquisitionValue,
    DateTime? acquisitionDate,
    String? supplier,
    String? location,
    String? areaId,
    String? responsibleId,
    String? custodianId,
    String? observations,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AssetModel(
      id: id ?? this.id,
      inventoryNumber: inventoryNumber ?? this.inventoryNumber,
      description: description ?? this.description,
      serialNumber: serialNumber ?? this.serialNumber,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      status: status ?? this.status,
      condition: condition ?? this.condition,
      acquisitionValue: acquisitionValue ?? this.acquisitionValue,
      acquisitionDate: acquisitionDate ?? this.acquisitionDate,
      supplier: supplier ?? this.supplier,
      location: location ?? this.location,
      areaId: areaId ?? this.areaId,
      responsibleId: responsibleId ?? this.responsibleId,
      custodianId: custodianId ?? this.custodianId,
      observations: observations ?? this.observations,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'inventoryNumber': inventoryNumber,
      'description': description,
      'serialNumber': serialNumber,
      'category': category,
      'subcategory': subcategory,
      'brand': brand,
      'model': model,
      'status': status,
      'condition': condition,
      'acquisitionValue': acquisitionValue,
      'acquisitionDate': acquisitionDate.millisecondsSinceEpoch,
      'supplier': supplier,
      'location': location,
      'areaId': areaId,
      'responsibleId': responsibleId,
      'custodianId': custodianId,
      'observations': observations,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory AssetModel.fromMap(Map<String, dynamic> map) {
    return AssetModel(
      id: map['id'] ?? '',
      inventoryNumber: map['inventoryNumber'] ?? '',
      description: map['description'] ?? '',
      serialNumber: map['serialNumber'],
      category: map['category'] ?? '',
      subcategory: map['subcategory'] ?? '',
      brand: map['brand'] ?? '',
      model: map['model'] ?? '',
      status: map['status'] ?? '',
      condition: map['condition'] ?? '',
      acquisitionValue: map['acquisitionValue']?.toDouble() ?? 0.0,
      acquisitionDate: DateTime.fromMillisecondsSinceEpoch(
        map['acquisitionDate'],
      ),
      supplier: map['supplier'] ?? '',
      location: map['location'] ?? '',
      areaId: map['areaId'] ?? '',
      responsibleId: map['responsibleId'] ?? '',
      custodianId: map['custodianId'] ?? '',
      observations: map['observations'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AssetModel.fromJson(String source) =>
      AssetModel.fromMap(json.decode(source));
}

enum AssetStatus { active, inactive, maintenance, disposed, missing, surplus }

enum AssetCondition { excellent, good, fair, poor, damaged }
