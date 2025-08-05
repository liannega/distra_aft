import 'package:uuid/uuid.dart';

class GenerateId {
  static String generateId() {
    final uuid = Uuid();
    return uuid.v4();
  }
}
