import 'package:flutter/material.dart';
import 'dart:math' as math;

class BoundingBox extends StatelessWidget {
  final List<dynamic> results;
  final List<Widget> boxes = [];
  final int previewH;
  final int previewW;
  final int screenH;
  final int screenW;
  List colors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.amber,
    Colors.blue,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.pink,
    Colors.teal
  ];
  math.Random random = new math.Random();

  BoundingBox(
    this.results,
    this.previewH,
    this.previewW,
    this.screenH,
    this.screenW,
  );
  // var re = globals.ray;
  @override
  Widget build(BuildContext context) {
    List<Widget> _renderBox() {
      print("Res is");
      print(previewH);
      print(previewW);
      print(screenW);
      print(screenH);

      for (var result in results) {
        var in_x = result[1][1];
        var in_w = result[1][3] - result[1][1];
        var in_y = result[1][0];
        var in_h = result[1][2] - result[1][0];
        var x = 0.0;
        var y = 0.0;
        var w = 0.0;
        var h = 0.0;
        var detectedClass = result[0];
        var scaleW, scaleH;

        if (screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;
          var difW = (scaleW - screenW) / scaleW;
          x = (in_x - difW / 2) * scaleW;
          w = in_w * scaleW;
          if (in_x < difW / 2) w -= (difW / 2 - in_x) * scaleW;
          y = in_y * scaleH;
          h = in_h * scaleH;
        } else {
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          var difH = (scaleH - screenH) / scaleH;
          x = in_x * scaleW;
          w = in_w * scaleW;
          y = (in_y - difH / 2) * scaleH;
          h = in_h * scaleH;

          //print(re["detectedClass"]);
          if (in_y < difH / 2) h -= (difH / 2 - in_y) * scaleH;
        }

        var index = random.nextInt(9);

        boxes.add(Positioned(
          left: x,
          top: y,
          width: w,
          height: h,
          child: Container(
            // padding: EdgeInsets.only(top: 5.0, left: 5.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: colors[index],
                width: 3.0,
              ),
            ),
            child: Text(
              detectedClass,
              style: TextStyle(
                color: Colors.white,
                backgroundColor: colors[index],
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
      }

      return boxes;
    }

    return Stack(
      children: _renderBox(),
    );
  }
}
