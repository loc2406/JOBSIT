import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class CVViewerScreen extends StatelessWidget {
  const CVViewerScreen({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Xem CV (PDF)"), backgroundColor: Colors.white,),
      body: PDFView(filePath: path,));
  }
}
