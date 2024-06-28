import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PDFViewer extends StatefulWidget {
  final int collecte;

  const PDFViewer({super.key, required this.collecte});

  @override
  // ignore: library_private_types_in_public_api
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  String pathPDF = "";

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  loadPdf() async {
    var response = await http.get(Uri.parse(
        'http://larrc.vigilience.corp/Clp/Collect/${widget.collecte}/PDF'));
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
          title: const Text('PDF Viewer'),
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
