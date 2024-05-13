import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;

class ImageUpload extends StatefulWidget {
  const ImageUpload(
      {super.key, required this.typeDepot, required this.idMission});

  final typeDepot;
  final idMission;

  @override
  // ignore: library_private_types_in_public_api
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
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

  // Future<void> _pickImage() async {
  //   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = Future.value(XFile(pickedFile.path));
  //     });
  //   }
  // }

  sendImageToAPI(List<XFile> imageFile, typeDepot, mission) async {
    var uri = Uri.parse(
        'http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/mission/setPicture'); // Replace with your API endpoint
    var index = 0;
    for (XFile e in imageFileList!) {
      var request = http.MultipartRequest('POST', uri);

      request.headers['authorization'] = 'Bearer ${globals.token}';
      request.headers['Content-Type'] = 'image/jpeg';
      request.fields['type'] = typeDepot;
      request.fields['mission'] = mission.id.toString();
      var bytes = File(e.path).readAsBytesSync();
      request.fields['image'] = base64Encode(bytes);
      try {
        var response = await request.send();
        var r = await http.Response.fromStream(response);
        if (response.statusCode == 200) {
          setState(() {
            afficheCircles[index] = true;
          });
        } else {
          print('Failed to upload image. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error uploading image: $e');
      }
      index++;
    }
  }

//   Future<void> sendImageToAPI(File imageFile, typeDepot, idMission) async {
//   var uri = Uri.parse('http://mesprojets-laravel.mborgna.vigilience.corp/api/clp/mission/setPicture'); // Replace with your API endpoint

//   var request = http.MultipartRequest('POST', uri);

//   request.headers['authorization'] = 'Bearer ${globals.token}';
//   request.headers['Content-Type'] = 'image/jpeg';
//   request.fields['type'] = typeDepot;
//   request.fields['mission'] = idMission.toString();
//   request.fields['name'] = imageFile.path.split(Platform.pathSeparator).last;
//   var bytes = File(imageFile.path).readAsBytesSync();
//   request.fields['image'] = base64Encode(bytes);
//   // request.files.add(
//   //   http.MultipartFile.fromBytes(
//   //     'image', File(imageFile.path).readAsBytesSync(),
//   //     filename: 'image.jpg'

//   //     ));

//   try {
//     var response = await request.send();
//     var r = await http.Response.fromStream(response);
//     if (response.statusCode == 200) {
//       print(r.body);
//       print('Image uploaded successfully');

//     } else {
//       print('Failed to upload image. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error uploading image: $e');
//   }
// }

  @override
  void initState() {
    super.initState();
    // ignore: null_argument_to_non_null_type
    // _imageFile = Future.value(null);
    //imageFileList
    imageFileList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gestion des photos'),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    afficheCirclesAll = true;
                  });
                  sendImageToAPI(
                      imageFileList!, widget.typeDepot, widget.idMission);
                },
                icon: Icon(Icons.import_export))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            print('press');

            _pickMultiImage();
            // _pickImage();
          },
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: imageFileList!.isEmpty 
                  ? Padding(
                    padding: const EdgeInsets.all(80.0),
                    child: Center(child: Text('Zone de téléchagement. Cliquez sur le bouton [ + ] pour ajouter des photos')),
                  ) 
                  : GridView.builder(
                      itemCount: imageFileList!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8),
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity:
                                  (!afficheCircles[index] && afficheCirclesAll)
                                      ? 0.5
                                      : 1,
                              child: Image.file(
                                File(imageFileList![index].path),
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (!afficheCircles[index] && afficheCirclesAll)
                              const CircularProgressIndicator()
                          ],
                        );
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}
