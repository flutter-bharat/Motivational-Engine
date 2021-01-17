import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'dart:ui' as ui;
class FreeTransformText extends StatefulWidget {
  @override
  _FreeTransformTextState createState() => _FreeTransformTextState();
}

class _FreeTransformTextState extends State<FreeTransformText> {
  GlobalKey _globalKey = new GlobalKey();
  Uint8List imageInMemory;

  Future<Uint8List> _capturePng() async {
    RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();

    if (boundary.debugNeedsPaint) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
      return _capturePng();
    }

    var image = await boundary.toImage(pixelRatio: 3);
    var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData.buffer.asUint8List();
  }

  void _printPngBytes() async {
    var pngBytes = await _capturePng();
    setState(() {
      imageInMemory = pngBytes;
    });
    var bs64 = base64Encode(pngBytes);
    print(pngBytes);
    print(bs64);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Widget To Image demo'),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'click below given button to capture iamge',
              ),
              new RaisedButton(
                child: Text('capture Image'),
                onPressed: _printPngBytes,
              ),
              imageInMemory != null
                  ? Container(
                  child: Image.memory(imageInMemory),
                  margin: EdgeInsets.all(10))
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}


// following code is executed inside a State

