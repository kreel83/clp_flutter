import 'dart:io';

import 'package:clp_flutter/pages/image_upload.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;

class _PickImage extends State<ImageUpload> {
  // late Future<XFile?> _imageFile;

  late List<XFile>? imageFileList = [];
  final ImagePicker imagePicker = ImagePicker();
  List<bool> afficheCircles = [];
  bool afficheCirclesAll = false;

  Future<void> _pickMultiImage() async {
    final List<XFile> selectedImages =
        (await imagePicker.pickMultiImage()).cast<XFile>();
    if (selectedImages.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {
      for (XFile element in selectedImages) {
        afficheCircles.add(false);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
