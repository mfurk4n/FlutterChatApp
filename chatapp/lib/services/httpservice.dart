import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class HttpService {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  static const baseUrl = "10.0.2.2:3000";
  Future<http.Response> getReq(String adress) async {
    var url = Uri.http(baseUrl, "/$adress");
    var response =
        await http.get(url, headers: {"Content-type": "application/json"});
    return response;
  }

  Future<http.Response> postOne(String data, String adress) async {
    var url = Uri.http(baseUrl, "/$adress");
    var req = jsonEncode({"data": data});
    var response = await http.post(url,
        headers: {"Content-type": "application/json"}, body: req);
    return response;
  }
}
