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
import 'package:afia_plus_app/l10n/app_localizations.dart';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';

class PrescriptionPage extends StatelessWidget {
  const PrescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authState is! AuthenticatedPatient) {
          return const Scaffold(
            body: Center(
              child: Text('Please log in as a patient to view prescriptions.'),
            ),
          );
        }

        final patientId = authState.patient.userId!;

        return BlocProvider(
          create: (context) =>
              PrescriptionCubit()..loadPrescriptions(patientId),
          child: _PrescriptionPageView(patientId: patientId),
        );
      },
    );
  }
}

class _PrescriptionPageView extends StatelessWidget {
  final int patientId;
  const _PrescriptionPageView({required this.patientId});

  Widget _buildPrescriptionCard({
    required BuildContext context,
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
                  if (context.mounted) {
                    _showError(
                      context,
                      AppLocalizations.of(context)!.noPrescriptionAvailable,
                    );
                  }
                  return;
                }

                try {
                  // Check if it's a Supabase URL (cloud storage)
                  if (PDFService.isSupabaseUrl(prescriptionPath)) {
                    await _openSupabasePDF(
                      context,
                      prescriptionPath,
                      consultation.consultation.consultationId!,
                    );
                  }
                  // Check if it's an asset path
                  else if (PDFService.isAssetPath(prescriptionPath)) {
                    await _openAssetPDF(context, prescriptionPath);
                  } else {
                    // It's a stored file path (legacy)
                    await _openStoredPDF(context, prescriptionPath);
                  }
                } catch (e) {
                  if (context.mounted) {
                    _showError(
                      context,
                      AppLocalizations.of(context)!.pdfOpenFailed(e.toString()),
                    );
                  }
                }
              },
              icon: const Icon(Icons.download_rounded, color: darkGreenColor),
              label: Text(
                AppLocalizations.of(context)!.viewPrescription,
                style: const TextStyle(
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
                return const Center(child: CircularProgressIndicator());
              }

              if (state.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.error}: ${state.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<PrescriptionCubit>()
                              .refreshPrescriptions(patientId);
                        },
                        child: Text(AppLocalizations.of(context)!.retry),
                      ),
                    ],
                  ),
                );
              }

              if (state.prescriptions.isEmpty) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
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
                          Expanded(
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.myPrescriptions,
                                style: const TextStyle(
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
                      Text(
                        AppLocalizations.of(context)!.noPrescriptionsFound,
                        style: const TextStyle(color: greyColor, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PrescriptionCubit>().refreshPrescriptions(
                    patientId,
                  );
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                color: darkGreenColor,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
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
                          Expanded(
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.myPrescriptions,
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
                      ...state.prescriptions.map(
                        (consultation) => _buildPrescriptionCard(
                          context: context,
                          consultation: consultation,
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const UserFooter(currentIndex: 2),
    );
  }

  /// Open PDF from Supabase Storage URL
  Future<void> _openSupabasePDF(
    BuildContext context,
    String publicUrl,
    int consultationId,
  ) async {
    try {
      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.downloadingPdf),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Check if already cached locally
      File? pdfFile = await PDFService.getCachedPDF(consultationId);

      // If not cached, download from Supabase
      if (pdfFile == null || !await pdfFile.exists()) {
        pdfFile = await PDFService.downloadFromSupabase(
          publicUrl,
          consultationId,
        );
      }

      // Open the file
      final result = await OpenFilex.open(pdfFile.path);
      if (result.type != ResultType.done) {
        if (context.mounted) {
          _showError(context, AppLocalizations.of(context)!.pdfOpenFailed(''));
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showError(
          context,
          AppLocalizations.of(context)!.pdfOpenFailed(e.toString()),
        );
      }
    }
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
        if (context.mounted) {
          _showError(context, AppLocalizations.of(context)!.pdfOpenFailed(''));
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showError(
          context,
          AppLocalizations.of(context)!.pdfOpenFailed(e.toString()),
        );
      }
    }
  }

  /// Open PDF from stored path
  Future<void> _openStoredPDF(BuildContext context, String storedPath) async {
    try {
      final pdfFile = await PDFService.getPDFFile(storedPath);
      if (pdfFile == null || !await pdfFile.exists()) {
        if (context.mounted) {
          _showError(context, AppLocalizations.of(context)!.pdfFileNotFound);
        }
        return;
      }

      // Open the file
      final result = await OpenFilex.open(pdfFile.path);
      if (result.type != ResultType.done) {
        if (context.mounted) {
          _showError(context, AppLocalizations.of(context)!.pdfOpenFailed(''));
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showError(
          context,
          AppLocalizations.of(context)!.pdfOpenFailed(e.toString()),
        );
      }
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
