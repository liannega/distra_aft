import 'package:dsimcaf_1/data/datasourse/api.dart';
import 'package:dsimcaf_1/domain/repositories/remote_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = Provider<RemoteRepository>((ref) {
  return Api.getInstance();
});