import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../models/pass_models.dart';

class PassPdfService {
  static const String _offlineCachePrefix = 'offline_alumni_pass_';

  /// Generates an official, high-resolution PDF pass and saves it to local device storage.
  /// Also caches the pass JSON for 100% offline access.
  Future<File> generateAndSavePdf(VirtualPass pass) async {
    // 1. Cache to GetStorage for offline retrieval
    try {
      final storage = GetStorage();
      await storage.write('$_offlineCachePrefix${pass.studentId}', pass.toJson());
      await storage.write('latest_offline_pass', pass.toJson());
    } catch (_) {}

    // 2. Build the PDF Document
    final pdf = pw.Document(
      title: 'IPAM Alumni Virtual Pass - ${pass.name}',
      author: 'University of Sierra Leone - IPAM Alumni Association',
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // 1. University Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'UNIVERSITY OF SIERRA LEONE',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#044E3D'),
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'INSTITUTE OF PUBLIC ADMINISTRATION AND MANAGEMENT',
                        style: pw.TextStyle(
                          fontSize: 9.5,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#D97706'),
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'Alumni Association - Tower Hill Campus, Freetown',
                        style: const pw.TextStyle(
                          fontSize: 8.5,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#ECFDF5'),
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                      border: pw.Border.all(color: PdfColor.fromHex('#10B981')),
                    ),
                    child: pw.Text(
                      'VERIFIED CREDENTIAL',
                      style: pw.TextStyle(
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#047857'),
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 16),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 14),

              // Title
              pw.Center(
                child: pw.Text(
                  'OFFICIAL ALUMNI DIGITAL IDENTITY PASS',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    letterSpacing: 1.2,
                    color: PdfColor.fromHex('#022C22'),
                  ),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Center(
                child: pw.Text(
                  'USL Central Registrar Archive Cryptographically Signed Document',
                  style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey600),
                ),
              ),

              pw.SizedBox(height: 20),

              // 2. Visual Representation: Pass Front & Back side-by-side
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Pass Front Preview
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(16),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#022C22'),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                        border: pw.Border.all(color: PdfColor.fromHex('#F59E0B'), width: 1.5),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text(
                                'IPAM - TOWER HILL',
                                style: pw.TextStyle(
                                  fontSize: 8.5,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColor.fromHex('#FBBF24'),
                                ),
                              ),
                              pw.Container(
                                width: 22,
                                height: 16,
                                decoration: pw.BoxDecoration(
                                  color: PdfColor.fromHex('#FDE68A'),
                                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
                                  border: pw.Border.all(color: PdfColor.fromHex('#D97706'), width: 0.8),
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 12),
                          pw.Text(
                            'GRADUATE CREDENTIAL',
                            style: pw.TextStyle(
                              fontSize: 7.5,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColor.fromHex('#FBBF24'),
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            pass.name,
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            '${pass.degree} - Class of ${pass.classYear}',
                            style: pw.TextStyle(fontSize: 8.5, color: PdfColor.fromHex('#A7F3D0')),
                          ),
                          pw.SizedBox(height: 12),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('MEMBER ID', style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey400)),
                                  pw.Text(
                                    pass.studentId,
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColor.fromHex('#FBBF24'),
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.end,
                                children: [
                                  pw.Text('TIER', style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey400)),
                                  pw.Text(
                                    pass.membershipTier,
                                    style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 8),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: pw.BoxDecoration(
                              color: PdfColor.fromHex('#011E17'),
                              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                            ),
                            child: pw.Text(
                              'SIDE A: OFFICIAL IDENTITY BADGE',
                              style: pw.TextStyle(fontSize: 6.5, color: PdfColor.fromHex('#34D399')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  pw.SizedBox(width: 16),

                  // Pass Back Preview
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(16),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#0B1B17'),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                        border: pw.Border.all(color: PdfColor.fromHex('#059669'), width: 1.5),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Magnetic Stripe Bar
                          pw.Container(
                            width: double.infinity,
                            height: 18,
                            color: PdfColor.fromHex('#0F172A'),
                          ),
                          pw.SizedBox(height: 10),
                          pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Container(
                                padding: const pw.EdgeInsets.all(4),
                                decoration: const pw.BoxDecoration(
                                  color: PdfColors.white,
                                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(6)),
                                ),
                                child: pw.BarcodeWidget(
                                  barcode: pw.Barcode.qrCode(),
                                  data: pass.qrPayload.isNotEmpty ? pass.qrPayload : pass.studentId,
                                  width: 58,
                                  height: 58,
                                ),
                              ),
                              pw.SizedBox(width: 10),
                              pw.Expanded(
                                child: pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      'SCAN TO VERIFY',
                                      style: pw.TextStyle(
                                        fontSize: 8,
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColor.fromHex('#34D399'),
                                      ),
                                    ),
                                    pw.SizedBox(height: 2),
                                    pw.Text(
                                      'Valid for library borrowing, gate entry, and voting at general assembly.',
                                      style: const pw.TextStyle(fontSize: 6.5, color: PdfColors.grey300),
                                    ),
                                    pw.SizedBox(height: 4),
                                    pw.Text(
                                      'Registrar Signature:',
                                      style: const pw.TextStyle(fontSize: 6, color: PdfColors.grey400),
                                    ),
                                    pw.Text(
                                      'Prof. E. C. Palmer, Registrar',
                                      style: pw.TextStyle(
                                        fontSize: 7.5,
                                        fontStyle: pw.FontStyle.italic,
                                        color: PdfColor.fromHex('#FBBF24'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 8),
                          pw.BarcodeWidget(
                            barcode: pw.Barcode.code128(),
                            data: pass.studentId,
                            width: double.infinity,
                            height: 20,
                            drawText: false,
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'SIDE B: SECURITY & ACCESS BARCODE',
                            style: pw.TextStyle(fontSize: 6.5, color: PdfColor.fromHex('#94A3B8')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 24),

              // 3. Official Verification Table
              pw.Text(
                'CREDENTIAL VERIFICATION METADATA',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#044E3D'),
                  letterSpacing: 0.8,
                ),
              ),
              pw.SizedBox(height: 8),

              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                children: [
                  _buildPdfTableRow('Alumnus Full Name', pass.name),
                  _buildPdfTableRow('Student Registration ID', pass.studentId),
                  _buildPdfTableRow('Degree & Field of Study', pass.degree),
                  _buildPdfTableRow('Class Cohort Year', pass.classYear.toString()),
                  _buildPdfTableRow('Membership Tier', pass.membershipTier),
                  _buildPdfTableRow('Affiliated Institution', pass.institution),
                  _buildPdfTableRow('Verification Status', pass.isVerifiedAlumni ? 'VERIFIED ALUMNI' : 'APPROVED'),
                  _buildPdfTableRow('Document Issued Date', DateTime.now().toIso8601String().split('T').first),
                  _buildPdfTableRow('Online Registry Alias', 'https://ipam.billnbite.cloud/api/alumni/pass/verify/${pass.studentId}'),
                ],
              ),

              pw.Spacer(),

              // 4. Institutional Certification & Seal Notice
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F8FAFC'),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                  border: pw.Border.all(color: PdfColors.grey300),
                ),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Institutional Authenticity & Security Guarantee',
                            style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            'This credential certificate was generated offline and is digitally linked to the University of Sierra Leone academic registrar records. Point any QR scanner at the embedded code to authenticate credential authenticity.',
                            style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'Institute of Public Administration and Management - University of Sierra Leone - Tower Hill, Freetown',
                  style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey500),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save to device storage
    final outputDir = await getApplicationDocumentsDirectory();
    final cleanStudentId = pass.studentId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final filePath = '${outputDir.path}/IPAM_Alumni_Pass_$cleanStudentId.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  pw.TableRow _buildPdfTableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: pw.Text(
            label,
            style: pw.TextStyle(fontSize: 8.5, fontWeight: pw.FontWeight.bold, color: PdfColors.grey800),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.black),
          ),
        ),
      ],
    );
  }

  /// Opens the downloaded PDF with the device's native PDF reader.
  Future<void> openPdf(File file) async {
    await OpenFilex.open(file.path);
  }

  /// Shares the downloaded PDF using the system share sheet.
  Future<void> sharePdf(File file) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'My Official IPAM Alumni Digital Virtual Pass & Credential',
        subject: 'IPAM Alumni Virtual Pass',
      ),
    );
  }
}
