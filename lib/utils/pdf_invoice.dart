import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class PdfInvoice {
  static Future<String> generateInvoice({
    required String orderId,
    required String userAddress,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
  }) async {
    print("🖨 PDF Invoice Generating - Total Amount: \$${totalAmount}");

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Invoice", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text("Order ID: $orderId"),
            pw.Text("Delivery Address: $userAddress"),
            pw.SizedBox(height: 10),
            pw.Text("Items:", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.Table.fromTextArray(
              context: context,
              data: [
                ["Product", "Quantity", "Price"],
                ...items.map((item) => [item['name'], item['quantity'], item['price']]),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Text("Total Amount: ${totalAmount.toStringAsFixed(2)}",
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/invoice_$orderId.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  static Future<void> shareInvoiceOnWhatsApp(String filePath) async {
    try {
      await Share.shareXFiles([XFile(filePath)], text: "Here is your invoice.");
    } catch (e) {
      print("Error sharing invoice: $e");
    }
  }
}
