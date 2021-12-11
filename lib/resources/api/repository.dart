import 'dart:async';

import 'package:junior_test/model/root_response.dart';

import 'mall_api_provider.dart';

class Repository {
  final mallApiProvider = MallApiProvider();

  Future<RootResponse> fetchActionInfo(int id) =>
      mallApiProvider.fetchActionInfo(id);

  Future<RootResponse> fetchActionInfoAll(int page, int count) =>
      mallApiProvider.fetchActionInfoAll(page, count);
}
