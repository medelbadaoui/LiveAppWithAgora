import 'dart:io';

import 'package:agorartm/screen/agora/awsmodel.dart';
import 'package:agorartm/screen/agora/host.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class RecordedLive extends StatefulWidget {
  @override
  RecordedLive_State createState() => RecordedLive_State();
}

class RecordedLive_State extends State<RecordedLive> {
  VideoPlayerController _controller;
  AwsModel awsModel = AwsModel();
  File video;

  initvideo() async {
    await _downloadFile(CallPage.recordedlivefile).then((value) {
      _controller = VideoPlayerController.file(value);
      video = value;
    });
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
  }

  Future<File> _downloadFile(String filename) async {
    var response = await awsModel.gettData(filename);
    print(response);
    var bytes = response;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    print(file);
    return file;
  }

  @override
  void initState() {
    super.initState();
    if (CallPage.recordedlivefile != null) initvideo();
  }

  @override
  void dispose() {
    if (_controller != null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (video == null)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (CallPage.recordedlivefile != null)
                        ? CircularProgressIndicator()
                        : SizedBox(),
                    SizedBox(
                      height: 30,
                    ),
                    (CallPage.recordedlivefile != null)
                        ? Text('Your Live Video is Loading ...')
                        : Text('No live is recorded !')
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                children: <Widget>[
                  Container(padding: const EdgeInsets.only(top: 20.0)),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          VideoPlayer(_controller),
                          ClosedCaption(text: _controller.value.caption.text),
                          _PlayPauseOverlay(controller: _controller),
                          VideoProgressIndicator(_controller,
                              allowScrubbing: true),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
      ),
    );
  }
}

class _PlayPauseOverlay extends StatelessWidget {
  const _PlayPauseOverlay({Key key, this.controller}) : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
