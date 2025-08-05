import 'package:dsimcaf_1/data/api/datasourse/api.dart';
import 'package:dsimcaf_1/domain/repositories/remote/remote_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = Provider<RemoteRepository>((ref) {
  return Api.getInstance();
});