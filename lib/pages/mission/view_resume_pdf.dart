import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart'; // Import du package

class ResumeViewer extends StatefulWidget {
  final int mission;

  const ResumeViewer({super.key, required this.mission});

  @override
  // ignore: library_private_types_in_public_api
  _ResumeViewerState createState() => _ResumeViewerState();
}

class _ResumeViewerState extends State<ResumeViewer> {
  String pathPDF = "";

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  loadPdf() async {
    var uri = Uri.parse(
        'https://www.la-gazette-eco.fr/api/clp/resume/${widget.mission}'); // Replace with your API endpoint

    var client = http.Client();

    var response = await client.get(uri);
    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/data.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    setState(() {
      pathPDF = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mon résumé'),
        ),
        body: pathPDF.isNotEmpty
            ? PDFView(
                filePath: pathPDF,
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}
