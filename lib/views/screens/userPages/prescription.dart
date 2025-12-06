import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/widgets/footer_user.dart';
import 'package:afia_plus_app/cubits/prescription_cubit.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';
import 'package:afia_plus_app/utils/pdf_service.dart';

class PrescriptionPage extends StatelessWidget {
  const PrescriptionPage({super.key});

  // TODO: Replace with actual patient ID from authentication/session
  static const int patientId = 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrescriptionCubit()..loadPrescriptions(patientId),
      child: const _PrescriptionPageView(),
    );
  }
}

class _PrescriptionPageView extends StatelessWidget {
  const _PrescriptionPageView();

  Widget _buildPrescriptionCard({
    required ConsultationWithDetails consultation,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.80),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: darkGreenColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Dr. ${consultation.doctorFullName}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: blackColor,
              ),
            ),
            subtitle: Text(
              consultation.formattedDate,
              style: const TextStyle(fontSize: 14, color: greyColor),
            ),
            trailing: const Icon(Icons.more_vert, color: greyColor),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final prescriptionPath = consultation.consultation.prescription;
                if (prescriptionPath == null || prescriptionPath.isEmpty) {
                  _showError(context, 'No prescription available');
                  return;
                }

                try {
                  // Check if it's an asset path
                  if (PDFService.isAssetPath(prescriptionPath)) {
                    await _openAssetPDF(context, prescriptionPath);
                  } else {
                    // It's a stored file path
                    await _openStoredPDF(context, prescriptionPath);
                  }
                } catch (e) {
                  _showError(context, 'Failed to open PDF: ${e.toString()}');
                }
              },
              icon: const Icon(Icons.download_rounded, color: darkGreenColor),
              label: const Text(
                "View Prescription",
                style: TextStyle(
                  color: darkGreenColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: darkGreenColor, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradientBackgroundDecoration,
        child: SafeArea(
          child: BlocBuilder<PrescriptionCubit, PrescriptionState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${state.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<PrescriptionCubit>().refreshPrescriptions(PrescriptionPage.patientId);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state.prescriptions.isEmpty) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: darkGreenColor,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                "My Prescriptions",
                                style: TextStyle(
                                  color: blackColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'No prescriptions available',
                        style: TextStyle(color: greyColor, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: darkGreenColor,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              "My Prescriptions",
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...state.prescriptions.map((consultation) => _buildPrescriptionCard(
                          consultation: consultation,
                        )),
                    const SizedBox(height: 80),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const UserFooter(currentIndex: 2),
    );
  }

  /// Open PDF from assets
  Future<void> _openAssetPDF(BuildContext context, String assetPath) async {
    try {
      // Load asset as bytes
      final ByteData data = await rootBundle.load(assetPath);
      final List<int> bytes = data.buffer.asUint8List();

      // Save to temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = path.basename(assetPath);
      final tempFile = File(path.join(tempDir.path, fileName));
      await tempFile.writeAsBytes(bytes);

      // Open the file
      final result = await OpenFilex.open(tempFile.path);
      if (result.type != ResultType.done) {
        _showError(context, 'Failed to open PDF file');
      }
    } catch (e) {
      _showError(context, 'Error loading PDF: ${e.toString()}');
    }
  }

  /// Open PDF from stored path
  Future<void> _openStoredPDF(BuildContext context, String storedPath) async {
    try {
      final pdfFile = await PDFService.getPDFFile(storedPath);
      if (pdfFile == null || !await pdfFile.exists()) {
        _showError(context, 'PDF file not found');
        return;
      }

      // Open the file
      final result = await OpenFilex.open(pdfFile.path);
      if (result.type != ResultType.done) {
        _showError(context, 'Failed to open PDF file');
      }
    } catch (e) {
      _showError(context, 'Error opening PDF: ${e.toString()}');
    }
  }

  /// Show error message
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
