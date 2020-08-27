import 'package:http/http.dart' as http;
import 'package:sigv4/sigv4.dart';

class AwsModel {
  String url = 'https://livestreamingapp.s3.us-east-2.amazonaws.com/';
  Future gettData(String input) async {
    String username = '***************';
    String password = '***************';
    final client = Sigv4Client(
      keyId: username,
      accessKey: password,
      region: 'us-east-2',
      serviceName: 's3',
    );
    var request = client.request(url + input);

    http.Response response =
        await http.get(request.url, headers: request.headers);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      print(response.statusCode);
      return response.body;
    }
  }
}
