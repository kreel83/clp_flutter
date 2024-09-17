import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart'; // Import du package

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
    var uri = Uri.parse(
        'https://www.la-gazette-eco.fr/api/clp/pdf/${widget.collecte}'); // Replace with your API endpoint

    var client = http.Client();

    var response = await client.get(uri);
    var dir = await getTemporaryDirectory();
    File file = File("${dir.path}/data.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    setState(() {
      pathPDF = file.path;
    });
  }

  Future<void> downloadPdf() async {
    var uri = Uri.parse(
        'https://www.la-gazette-eco.fr/api/clp/pdf/${widget.collecte}');
    var client = http.Client();
    var response = await client.get(uri);

    // Récupérer le répertoire temporaire
    Directory tempDir = await getTemporaryDirectory();

    // Créer le fichier dans le répertoire temporaire
    File file = File("${tempDir.path}/facture_${widget.collecte}.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text(
              "Le fichier a été téléchargé dans le répertoire temporaire")),
    );

    // Ouvrir le fichier PDF avec une application externe
    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ma facture'),
          actions: [
            IconButton(
                onPressed: downloadPdf, icon: const Icon(Icons.download)),
          ],
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
