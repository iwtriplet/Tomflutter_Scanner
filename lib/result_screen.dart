import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({Key? key, required this.text}) : super(key: key);

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Text copied to clipboard'),
      ),
    );
  }

  Future<void> _saveAsPdf(BuildContext context) async {
    try {
      final pdf = pdfLib.Document();

      pdf.addPage(
        pdfLib.Page(
          build: (context) {
            return pdfLib.Center(
              child: pdfLib.Text(text),
            );
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/tomflutter.pdf');

      await file.writeAsBytes(await pdf.save());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF saved successfully'),
        ),
      );

      // Buka file PDF dengan aplikasi eksternal
      OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving PDF'),
        ),
      );
      print('Error saving PDF: $e');
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Result'),
      centerTitle: true,
    ),
    body: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _copyToClipboard(context),
                child: Text('Copy to Clipboard'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _saveAsPdf(context),
                child: Text('Save as PDF'),
              ),
            ],
          ),
        ),
      );
}
}