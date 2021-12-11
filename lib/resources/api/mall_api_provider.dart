import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' show Client, Response;
import 'package:junior_test/model/root_response.dart';
import 'package:junior_test/resources/api/RootType.dart';

class MallApiProvider {
  Client client = Client();

  //'www.googleapis.com', '/books/v1/volumes',
  static const baseImageUrl = "https://bonus.andreyp.ru/";

  Future<RootResponse>  _baseGETfetchWithEvent(
      RootTypes event, String url) async {
    final _baseUrlMall = Uri.parse('https://bonus.andreyp.ru/api/v1/$url');
    try {
      Response response = await client.get(_baseUrlMall);
      if (response.statusCode == 200) {
        RootResponse resp = RootResponse.fromJson(json.decode(response.body));
        resp.setEventType(event);
        // print(response.body.length);
        return resp;
      } else {
        return RootResponse();
      }
    } on Exception catch (e) {
      if (!e.toString().contains('HttpException')) {
        RootResponse resp = RootResponse();
        resp.setEventType(RootTypes.EVENT_NETWORK_EXCEPTION);
        return resp;
      }
    }
  }

  Future<RootResponse> _basePOSTfetchWithEvent(
      RootTypes event, String url, Object args) async {
    final _baseUrlMall = Uri.parse('https://bonus.andreyp.ru/api/v1/$url');
    // print(_baseUrlMall + url);
    Response request = await client.post(_baseUrlMall,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: args);
    print(request.body);
    if (request.statusCode == 200) {
      RootResponse resp = RootResponse.fromJson(json.decode(request.body));
      resp.setEventType(event);
      return resp;
    } else {
      return RootResponse();
    }
  }

  Future<RootResponse> fetchActionInfoAll(int page, int count){
    return _baseGETfetchWithEvent(RootTypes.EVENT_HOME_LOAD, "promos?page=$page&count=$count");
  }

  Future<RootResponse> fetchActionInfo(int id) {
    return _baseGETfetchWithEvent(RootTypes.EVENT_ACTION_ITEM, "promo?id=$id");
  }
}
//https://bonus.andreyp.ru/api/v1/promos?page=1&count=1