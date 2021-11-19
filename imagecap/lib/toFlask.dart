import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

Future<dynamic> sendBackend(String imagePath) async {
  var request = MultipartRequest(
      'POST', Uri.parse('https://dlfl-captioning-image.herokuapp.com/api'));
  request.files.add(
    await MultipartFile.fromPath(
      'images',
      imagePath,
    ),
  );

  Response response = await Response.fromStream(await request.send());
  print(response.body);
  var x = jsonDecode(response.body);
  print(x);
  return x;
}
