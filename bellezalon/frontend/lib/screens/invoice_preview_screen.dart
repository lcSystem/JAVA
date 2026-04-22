import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../services/settings_provider.dart';
import '../services/api_service.dart';
import '../utils/formatters.dart';

class InvoicePreviewScreen extends StatefulWidget {
  final Map<String, dynamic> venta;

  const InvoicePreviewScreen({super.key, required this.venta});

  @override
  State<InvoicePreviewScreen> createState() => _InvoicePreviewScreenState();
}

class _InvoicePreviewScreenState extends State<InvoicePreviewScreen> {
  List<dynamic> _detalles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDetalles();
  }

  Future<void> _loadDetalles() async {
    try {
      final ventaId = int.tryParse(widget.venta['id'].toString());
      if (ventaId != null) {
        _detalles = await ApiService().getVentaDetalles(ventaId);
      }
    } catch (e) {
      debugPrint('Error fetch invoice details: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<pw.Document> _generatePdf(PdfPageFormat format, SettingsProvider settings) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    
    pw.ImageProvider? logoImage;
    if (settings.salonLogo.isNotEmpty) {
      try {
        if (settings.salonLogo.startsWith('/uploads')) {
          final imageUrl = '${ApiService.assetsBaseUrl}${settings.salonLogo}';
          logoImage = await networkImage(imageUrl);
        }
      } catch (e) {
        debugPrint("Error loading logo for pdf: $e");
      }
    }

    final double subtotal = double.tryParse(widget.venta['subtotal']?.toString() ?? '0') ?? 0;
    final double ivaPct = double.tryParse(widget.venta['iva_porcentaje']?.toString() ?? '0') ?? 0.0;
    final double ivaMonto = double.tryParse(widget.venta['iva_monto']?.toString() ?? '0') ?? 0.0;
    final double total = double.tryParse(widget.venta['total']?.toString() ?? '0') ?? 0;
    final double discount = double.tryParse(widget.venta['descuento']?.toString() ?? '0') ?? 0;

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (logoImage != null) pw.Image(logoImage, width: 80, height: 80),
                      pw.SizedBox(height: 8),
                      pw.Text(settings.salonName, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
                      pw.Text('Factura Electrónica', style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
                    ]
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Factura No: ${widget.venta['numero_factura']}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
                      pw.SizedBox(height: 4),
                      pw.Text('Fecha: ${widget.venta['fecha_venta']}'),
                      pw.Text('Estado: ${widget.venta['estado'].toString().toUpperCase()}'),
                    ]
                  ),
                ]
              ),
              pw.Divider(color: PdfColors.grey400, thickness: 1),
              pw.SizedBox(height: 12),
              
              // Cliente Info
              pw.Text('Faturar a:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800)),
              pw.Text('Cliente: ${widget.venta['cliente_nombre'] ?? 'Sin nombre'}'),
              pw.Text('Atendido por: ${widget.venta['empleado_nombre'] ?? 'General'}'),
              pw.Text('Método de pago: ${widget.venta['metodo_pago'] ?? 'Sin definir'}'),
              
              pw.SizedBox(height: 20),
              
              // Table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.blueGrey100),
                    children: [
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Descripción', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Cant.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center)),
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('P. Unitario', style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                      pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Subtotal', style: pw.TextStyle(fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right)),
                    ]
                  ),
                  ..._detalles.map((det) {
                    final desc = det['item_nombre'] ?? det['descripcion'] ?? 'Item';
                    final cant = int.tryParse(det['cantidad']?.toString() ?? '1') ?? 1;
                    final pu = double.tryParse(det['precio_unitario']?.toString() ?? '0') ?? 0;
                    return pw.TableRow(
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(desc)),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('$cant', textAlign: pw.TextAlign.center)),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(formatCurrency(pu), textAlign: pw.TextAlign.right)),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(formatCurrency(pu * cant), textAlign: pw.TextAlign.right)),
                      ]
                    );
                  }),
                  if (_detalles.isEmpty) 
                    pw.TableRow(
                      children: [
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('Servicios Consolidados')),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text('1', textAlign: pw.TextAlign.center)),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(formatCurrency(subtotal), textAlign: pw.TextAlign.right)),
                        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(formatCurrency(subtotal), textAlign: pw.TextAlign.right)),
                      ]
                    )
                ]
              ),
              
              pw.SizedBox(height: 16),
              
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    width: 200,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('Subtotal:'), pw.Text(formatCurrency(subtotal))]),
                        if (discount > 0)
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('Descuento:'), pw.Text(formatCurrency(discount), style: const pw.TextStyle(color: PdfColors.red))]),
                        if (ivaPct > 0)
                          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('Impuestos (${ivaPct}%):'), pw.Text(formatCurrency(ivaMonto))]),
                        pw.Divider(),
                        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text('TOTAL:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)), pw.Text(formatCurrency(total), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16))]),
                      ]
                    )
                  )
                ]
              ),
              
              pw.Spacer(),
              pw.Center(
                child: pw.Text('¡Gracias por su preferencia!', style: pw.TextStyle(color: PdfColors.grey600, fontStyle: pw.FontStyle.italic))
              ),
            ],
          );
        }
      )
    );

    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Factura: ${widget.venta['numero_factura']}'),
        backgroundColor: settings.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _loading 
        ? const Center(child: CircularProgressIndicator()) 
        : PdfPreview(
            build: (format) => _generatePdf(format, settings).then((doc) => doc.save()),
            pdfFileName: 'Factura_${widget.venta['numero_factura']}.pdf',
            canChangeOrientation: false,
            canChangePageFormat: false,
          ),
    );
  }
}
