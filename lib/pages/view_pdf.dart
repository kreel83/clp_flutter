import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:convert';
import '../../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';


class PDFViewer extends StatefulWidget {
  final int collecte;

  PDFViewer({required this.collecte});

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  late PDFViewController _pdfViewController;
  String pathPDF = "";

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  loadPdf() async {
    var response = await http.get(Uri.parse('http://larrc.vigilience.corp/Clp/Collect/${widget.collecte}/PDF'));
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
        title: Text('PDF Viewer'),
      ),
      body: pathPDF.isNotEmpty ? 
        PDFView(filePath: pathPDF,) 
        : Center(child: CircularProgressIndicator(),)
      
    );
  }
}