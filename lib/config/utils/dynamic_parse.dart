import 'dart:developer';

import 'package:flutter/foundation.dart';

typedef CustomParseFunction<T> = T Function(dynamic item);

//* Poner en true si quieres que el error se lanze fuera de la clase
const bool forceCrash = false;

class DynamicParse {
  static int toInt(dynamic data, int defaultValue) {
    return toIntOrNull(data) ?? defaultValue;
  }

  static int? toIntOrNull(dynamic data) {
    if (data == null) return null;
    if (data is int) return data;
    try {
      return int.parse('$data');
    } catch (e) {
      if (kDebugMode) {
        log("DynamicParseError general: $e");
        log(
          "DynamicParseError when trying to parse data of type ${data.runtimeType} to int",
        );
        log("DynamicParseError data: $data");
        if (forceCrash) rethrow;
      }
    }
    return null;
  }

  static double toDouble(dynamic data, double defaultValue) {
    return toDoubleOrNull(data) ?? defaultValue;
  }

  static double? toDoubleOrNull(dynamic data) {
    if (data == null) return null;
    if (data is double) return data;
    try {
      return double.parse('$data');
    } catch (e) {
      if (kDebugMode) {
        log("DynamicParseError general: $e");
        log(
          "DynamicParseError when trying to parse data of type ${data.runtimeType} to double",
        );
        log("DynamicParseError data: $data");
        if (forceCrash) rethrow;
      }
    }
    return null;
  }

  static num toNumber(dynamic data, double defaultValue) {
    return toNumberOrNull(data) ?? defaultValue;
  }

  static num? toNumberOrNull(dynamic data) {
    if (data == null) return null;
    if (data is num) return data;
    try {
      return num.parse('$data');
    } catch (e) {
      if (kDebugMode) {
        log("DynamicParseError general: $e");
        log(
          "DynamicParseError when trying to parse data of type ${data.runtimeType} to num",
        );
        log("DynamicParseError data: $data");
        if (forceCrash) rethrow;
      }
    }
    return null;
  }

  static T toObject<T>(
    dynamic data,
    CustomParseFunction<T> parseFunction,
    T defaultValue,
  ) {
    return toObjectOrNull<T>(data, parseFunction) ?? defaultValue;
  }

  static T? toObjectOrNull<T>(
    dynamic data,
    CustomParseFunction<T> parseFunction,
  ) {
    if (data == null) return null;
    try {
      return parseFunction(data);
    } catch (e) {
      if (kDebugMode) {
        log("DynamicParseError general: $e");
        log(
          "DynamicParseError when trying to parse data of type ${data.runtimeType} to $T",
        );
        log("DynamicParseError data: $data");
        if (forceCrash) rethrow;
      }
    }
    return null;
  }

  static List<T> toList<T>(
    dynamic dataList,
    CustomParseFunction<T> parseFunction,
  ) {
    final result = <T>[];
    if (dataList == null) return result;
    if (dataList is! Iterable) {
      if (kDebugMode) {
        log(
          "DynamicParseError when trying to parse data of type ${dataList.runtimeType} to ${List<T>}",
        );
        log("DynamicParseError data: $dataList");
        if (forceCrash) {
          throw ArgumentError(
            "DynamicParseError into toList() method because dataList is not Iterable",
          );
        }
      }
      return result;
    }
    try {
      for (final item in dataList) {
        try {
          result.add(parseFunction(item));
        } catch (e) {
          if (kDebugMode) {
            log("DynamicParseError general: $e");
            log(
              "DynamicParseError when trying to parse data of type ${item.runtimeType} to $T",
            );
            log("DynamicParseError data: $item");
            if (forceCrash) rethrow;
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        log("DynamicParseError general: $e");
        log(
          "DynamicParseError when trying to parse data of type ${dataList.runtimeType} to ${List<T>}",
        );
        log("DynamicParseError data: $dataList");
        if (forceCrash) rethrow;
      }
    }
    return result;
  }
}
