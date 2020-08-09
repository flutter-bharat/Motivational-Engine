import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class FreeTransformText extends StatefulWidget {
  @override
  _FreeTransformTextState createState() => _FreeTransformTextState();
}

class _FreeTransformTextState extends State<FreeTransformText> {
  Matrix4 matrix = Matrix4.identity();
  ValueNotifier<int> notifier = ValueNotifier(0);
  vector.Vector3 nodePosition = vector.Vector3(50, 0, 0);
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing Some Shit'),
      ),
      body: LayoutBuilder(
        builder: (ctx, constraints) {
          return MatrixGestureDetector(
            shouldRotate: true,
            onMatrixUpdate: (m, tm, sm, rm) {
              matrix = MatrixGestureDetector.compose(matrix, tm, sm, rm);
              notifier.value++;
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.topLeft,
              color: Color(0xff444444),
              child: AnimatedBuilder(
                animation: notifier,
                builder: (ctx, child) {
                  return Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack( // a stack in which all nodes are built
                        children: <Widget>[
                          buildNode()
                        ],
                      )
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }


// I made this into a method so the transformed matrix can be calculated at runtime
  Widget buildNode() {
    // create a clone of the main matrix and translate it by the node's position
    Matrix4 ma = matrix.clone();
    ma.translate(nodePosition.x, nodePosition.y);

    return Transform(
        transform: ma, // transform the node using the new (translated) matrix
        child: MatrixGestureDetector(
            shouldRotate: false,
            shouldScale: false,
            onMatrixUpdate: (m, tm, sm, rm) {
              Matrix4 change = tm;
              // move the node (in relation to the viewport zoom) when it's being dragged
              double sc = MatrixGestureDetector.decomposeToValues(matrix).scale;
              nodePosition += change.getTranslation() / sc;
              notifier.value++; // refresh view
            },
            // design a node holding a bool variable ('check')...
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 12,right: 12),
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                      child: IntrinsicWidth(
                          stepWidth: 24,
                          child: TextField(
                            maxLines: 8,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          )
                      ),
                    ),
                  ],
                ),
            )
        )
    );
  }

}


// following code is executed inside a State

