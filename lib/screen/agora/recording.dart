import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper({this.url});
  final String url;
  Future postData(var input) async {
    String username = '54eb58e39fc4441392eed5a134284151';
    String password = '53406b01095a404e9aaff533ccc477eb';
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    http.Response response =
        await http.post(url, body: input, headers: <String, String>{
      'authorization': basicAuth,
      'Content-Type': "application/json",
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }
}
