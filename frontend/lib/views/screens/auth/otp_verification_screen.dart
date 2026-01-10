import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:afia_plus_app/logic/cubits/auth/auth_cubit.dart';
import 'package:afia_plus_app/data/repo/auth/auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:afia_plus_app/views/screens/sign_up/profile_picture.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/l10n/app_localizations.dart';
import 'package:afia_plus_app/utils/localization_helper.dart';
import 'package:afia_plus_app/data/models/patient.dart';
import 'package:afia_plus_app/data/models/doctor.dart';
import 'package:afia_plus_app/data/repo/auth/token_provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String password;

  const OtpVerificationScreen({super.key, required this.email, required this.password});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  Timer? _timer;
  int _secondsRemaining = 300; // 5 minutes in seconds

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = 300;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {}); // To refresh UI
      }
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final AuthRepository _authRepository = GetIt.instance<AuthRepository>();
  
  bool _isVerifying = false;
  bool _isResending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Auto-focus first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      // Handle paste
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      int changed = 0;
      for (int i = 0; i < 6 && i < digits.length; i++) {
        if (_controllers[i].text != digits[i]) changed++;
        _controllers[i].text = digits[i];
        if (i < 5) {
          _focusNodes[i + 1].requestFocus();
        }
      }
      // Do not trigger auto-verify on paste; require explicit confirm button
      return;
    }

    if (value.isNotEmpty) {
      // Move to next field
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last field filled, optionally unfocus
        _focusNodes[index].unfocus();
      }
    } else {
      // Move to previous field on backspace
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
    setState(() {}); // Refresh UI if needed
  }

  String _getOtp() => _controllers.map((c) => c.text).join();

  void _onOtpFieldTap() {
    // Only clear error if user begins to edit a field after error
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _getOtp();
    if (otp.length != 6) {
      setState(() {
        _errorMessage = 'Please enter all 6 digits.';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      // Do NOT clear _errorMessage. It is cleared on field tap/edit only.
    });

    try {
      final result = await _authRepository.verifyOtp(widget.email, otp, widget.password);

      if (!mounted) return;

      // CRITICAL: Only show error when backend explicitly returns failure
      // Backend returns success (state=true) when Supabase verifyOtp succeeds AND email_confirmed_at is set
      if (result.state && result.data != null) {
        // Backend returned success - verification succeeded
        setState(() {
          _errorMessage = null; // Clear error only on actual success
          _isVerifying = false;
        });
        
        // Backend has already verified that Supabase verifyOtp succeeded
        // If backend returns success (verified: true), we trust it completely
        // The backend guarantees that if Supabase verifyOtp succeeded, verification is successful
        final user = result.data!;

        // Update auth state to reflect verified user
        // Wait a moment to ensure token is saved and available
        await Future.delayed(const Duration(milliseconds: 200));
        
        // Verify token is available before checking login status
        final tokenProvider = GetIt.instance<TokenProvider>();
        final token = tokenProvider.accessToken;
        if (token == null || token.isEmpty) {
          if (!mounted) return;
          setState(() {
            _errorMessage = 'Authentication token not received. Please try again.';
            _isVerifying = false;
            // Clear OTP fields
            for (var controller in _controllers) {
              controller.clear();
            }
            _focusNodes[0].requestFocus();
          });
          return;
        }
        
        final authCubit = context.read<AuthCubit>();
        await authCubit.checkLoginStatus();

        if (!mounted) return;

        // Double-check auth state before navigating
        final authState = authCubit.state;
        final bool authIsVerified = (authState is AuthenticatedPatient && authState.patient.isEmailVerified) ||
            (authState is AuthenticatedDoctor && authState.doctor.isEmailVerified);

        if (!authIsVerified) {
          // Auth state not updated properly - wait a bit and check again
          await Future.delayed(const Duration(milliseconds: 500));
          await authCubit.checkLoginStatus();
          
          if (!mounted) return;
          
          final authState2 = authCubit.state;
          final bool authIsVerified2 = (authState2 is AuthenticatedPatient && authState2.patient.isEmailVerified) ||
              (authState2 is AuthenticatedDoctor && authState2.doctor.isEmailVerified);
          
          if (!authIsVerified2) {
            if (!mounted) return;
            setState(() {
              _errorMessage = 'Verification successful but authentication failed. Please try logging in with your email and password.';
              _isVerifying = false;
              // Clear OTP fields
              for (var controller in _controllers) {
                controller.clear();
              }
              _focusNodes[0].requestFocus();
            });
            return;
          }
        }

        // Ensure error is cleared before navigation
        if (mounted) {
          setState(() {
            _errorMessage = null;
          });
        }

        // Navigate to profile picture screen only if everything is verified
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePictureScreen()),
            (route) => false,
          );
        }
      } else {
        // Backend explicitly returned failure - only show error now
        if (!mounted) return;
        final isExpired = result.message != null && result.message.toString().toLowerCase().contains('expired');
        setState(() {
          _errorMessage = getLocalizedError(result.message, context) ?? result.message;
          _isVerifying = false;
          if (isExpired) {
            // Only clear if really expired
            for (var controller in _controllers) {
              controller.clear();
            }
            _focusNodes[0].requestFocus();
          }
        });
      }
    } catch (e) {
      // Network/exception errors - only show after request completes
      if (!mounted) return;
      setState(() {
        _errorMessage = AppLocalizations.of(context)?.error ?? 'An error occurred. Please try again.';
        _isVerifying = false;
      });
    }
  }

  Future<void> _resendOtp() async {
    if (_isResending || _secondsRemaining > 0) return;

    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      final result = await _authRepository.resendOtp(widget.email);

      if (!mounted) return;

      if (result.state) {
        // Restart timer
        _startTimer();
        // Clear OTP fields
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message.isNotEmpty ? result.message : 'New OTP code sent to your email'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        final errorMsg = getLocalizedError(result.message, context) ?? result.message;
        setState(() {
          _errorMessage = errorMsg;
        });
        // Show error snackbar as well
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg.isNotEmpty ? errorMsg : 'Failed to resend code. Please try again.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      String errorMsg = 'Failed to resend code. Please check your connection and try again.';
      if (e.toString().contains('timeout')) {
        errorMsg = 'Request timeout. Please check your connection and try again.';
      } else if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        errorMsg = 'Network error. Please check your internet connection and try again.';
      }
      setState(() {
        _errorMessage = errorMsg;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: gradientBackgroundDecoration,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: greyColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Enter the 6-digit code',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: greyColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'We\'ve sent the code to your email, check your inbox.',
                  style: TextStyle(
                    fontSize: 16,
                    color: greyColor.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 50,
                      height: 60,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: greyColor,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _errorMessage != null ? redColor : whiteColor.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _errorMessage != null ? redColor : whiteColor.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _errorMessage != null ? redColor : darkGreenColor,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) => _onDigitChanged(index, value),
                        onTap: _onOtpFieldTap,
                      ),
                    );
                  }),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: redColor,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                // Confirm button
                ElevatedButton(
                  onPressed: _isVerifying ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreenColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                  ),
                  child: _isVerifying
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 18),
                // Timer
                Text(
                  'This OTP will be available for ${_formatTime(_secondsRemaining)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: greyColor.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Resend code button
                TextButton(
                  onPressed: _secondsRemaining > 0 || _isResending ? null : _resendOtp,
                  child: Text(
                    _isResending ? 'Sending...' : 'Resend code',
                    style: TextStyle(
                      fontSize: 16,
                      color: _secondsRemaining > 0 || _isResending
                          ? greyColor.withOpacity(0.4)
                          : blueGreenColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (_isVerifying) ...[
                  const SizedBox(height: 24),
                  const Center(
                    child: CircularProgressIndicator(
                      color: darkGreenColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
