import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecap/drawBoxes.dart';
import 'package:imagecap/pillButton.dart';
import 'package:imagecap/toFlask.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  final picker = ImagePicker();
  String ocrtext = "";
  var k = null;
  var aspect = 0.0;
  bool indicatorStat = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);

      setState(() {
        indicatorStat = true;
      });

      k = await sendBackend(pickedFile.path);

      // List<dynamic> ocrop = k["text"];
      // String retstr = ocrop.join(",");
      print("It is : ${k['caption']}");
      print(k['caption'].runtimeType);
      // List<dynamic> ocrop = k["caption"];

      // String retstr = ocrop.join(",");

      String retstr = k['caption'];

      setState(() {
        indicatorStat = false;
        ocrtext = retstr;
        // aspect = k['resolution'][1] / k['resolution'][0];
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Image Captioning',
            textAlign: TextAlign.center,
            style: GoogleFonts.sourceSansPro(fontSize: 30),
          ),
        ),
        backgroundColor: Color(0xFF8A624A),
      ),
      body: Column(children: [
        Expanded(
          flex: 3,
          child: Stack(children: [
            // if (indicatorStat) {
            //   CircularProgressIndicator()
            // },
            _image == null
                ? Container(
                    color: Color(0xFFF8F0E3),
                    child: Center(
                        child: Text(
                      'Pick an Image for captioning',
                      style: GoogleFonts.sourceSansPro(fontSize: 20),
                    )),
                  )
                : Image.file(_image),
            // AspectRatio(
            //   aspectRatio: 1,
            //   child: Container(
            //     child: indicatorStat == true
            //         ? Container()
            //         : BoundingBox(
            //             k == null ? [] : k["output_data"],
            //             k == null ? 0 : k["resolution"][1],
            //             k == null ? 0 : k["resolution"][0],
            //             // Height
            //             k == null
            //                 ? 0
            //                 : k['resolution'][0] > k['resolution'][1]
            //                     ? ((k['resolution'][0] >= 400
            //                                 ? 400
            //                                 : k['resolution'][0]) *
            //                             aspect)
            //                         .toInt()
            //                     : k['resolution'][1] >= 500
            //                         ? 500
            //                         : k['resolution'][1],
            //             // Width
            //             k == null
            //                 ? 0
            //                 : k['resolution'][1] > k['resolution'][0]
            //                     ? (((k['resolution'][1] >= 500
            //                                 ? 500
            //                                 : k['resolution'][1])) /
            //                             aspect)
            //                         .toInt()
            //                     : k['resolution'][0] >= 400
            //                         ? 400
            //                         : k['resolution'][0],
            //           ),
            //   ),
            // ),
            indicatorStat == true
                ? Center(child: CircularProgressIndicator())
                : Container(),
          ]),
        ),
        Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              // height: 160,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10, color: Colors.grey, spreadRadius: 5)
                  ]),
              width: 420,
              // color: Colors.blueGrey,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Caption",
                        // style: TextStyle(
                        //   fontWeight: FontWeight.bold,
                        //   fontSize: 20,
                        // ),
                        style: GoogleFonts.sourceSansPro(fontSize: 20),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        // width: 350,
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F0E3),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        width: 350,
                        height: 150,
                        // color: Colors.blueGrey,
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(
                                      ocrtext,
                                      // style: GoogleFonts.comfortaa(),
                                    )),
                              ),
                            ]),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: RoundButton(
                          btn_color: Colors.redAccent,
                          onPressed: () {
                            Clipboard.setData(new ClipboardData(text: ocrtext));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              'Copied to Clipboard',
                              style: GoogleFonts.getFont('Source Sans Pro'),
                            )));
                          },
                        )),
                    Expanded(flex: 2, child: Container())
                  ]),
            ))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        backgroundColor: Color(0xFF8A624A),
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
