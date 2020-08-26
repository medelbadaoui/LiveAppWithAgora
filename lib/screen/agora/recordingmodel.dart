import 'dart:convert';

import 'package:agorartm/screen/agora/recording.dart';
import 'package:agorartm/utils/setting.dart';

const host = "https://api.agora.io/v1/apps/" + APP_ID + "/cloud_recording";

class RecordingModel {
  String cname = '';
  String uid = '';
  String _rid = '';
  String _sid = '';

  RecordingModel(String cname, String uid) {
    this.cname = cname;
    this.uid = uid;
  }

  Future<dynamic> acquire() async {
    NetworkHelper networkHelper = NetworkHelper(url: '$host' + '/acquire');
    print(cname);
    print(uid);
    final jsonStr = jsonEncode({
      "cname": cname,
      "uid": uid,
      "clientRequest": {"resourceExpiredHour": 24}
    });
    return await networkHelper.postData(jsonStr);
  }

  Future<dynamic> stop() async {
    NetworkHelper networkHelper = NetworkHelper(
        url: '$host' +
            '/resourceid/' +
            '$_rid' +
            '/sid/' +
            '$_sid' +
            '/mode/mix/stop');
    final jsonStr =
        jsonEncode({"cname": cname, "uid": uid, "clientRequest": {}});
    return await networkHelper.postData(jsonStr);
  }

  Future<dynamic> start() async {
    var acquireres = await acquire();
    Map<String, dynamic> map = acquireres;

    _rid = map['resourceId'];
    NetworkHelper networkHelper = NetworkHelper(
        url: '$host' + '/resourceid/' + '$_rid' + '/mode/mix/start');
    final jsonStr = jsonEncode({
      "cname": cname,
      "uid": uid,
      "clientRequest": {
        "recordingConfig": {
          "channelType": 0,
          "streamTypes": 2,
          "videoStreamType": 0,
          "maxIdleTime": 120,
          "transcodingConfig": {
            "width": 360,
            "height": 640,
            "fps": 30,
            "bitrate": 600,
            "maxResolutionUid": "1",
            "mixedVideoLayout": 1
          }
        },
        "storageConfig": {
          "vendor": 1,
          "region": 1,
          "bucket": "livestreamingapp",
          "accessKey": "AKIAINPFBOIFL24CL5WQ",
          "secretKey": "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"
        }
      }
    });
    var startres = await networkHelper.postData(jsonStr);
    Map<String, dynamic> mapres = startres;
    _sid = mapres['sid'];
    return startres;
  }
}
