
import 'package:flutter/material.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController =
      TextEditingController();

  bool _isLoading = false;

  static const Color blue = Color(0xFF087EFF);
  static const Color orange = Color(0xFFFF762E);
  static const Color navy = Color(0xFF092D70);
  static const Color textColor = Color(0xFF071A36);
  static const Color mutedColor = Color(0xFF718096);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _continueToOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Connect your backend here to send the actual OTP.
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() => _isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerificationScreen(
          email: _emailController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color(0xFFF8FBFF),
                  Color(0xFFEEF5FF),
                ],
              ),
            ),
          ),

          Positioned(
            top: -100,
            right: -100,
            child: _glowOrb(250, blue),
          ),

          Positioned(
            bottom: -120,
            left: -120,
            child: _glowOrb(280, orange),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 26,
                vertical: 20,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: navy,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Center(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/busiserve_logo.png',
                                width: 170,
                                height: 130,
                                fit: BoxFit.contain,
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.business_rounded,
                                    size: 85,
                                    color: Color(0xFF00AEEF),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'BUSINESS, MOVING FORWARD.',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        const Center(
                          child: Icon(
                            Icons.lock_reset_rounded,
                            color: navy,
                            size: 65,
                          ),
                        ),

                        const SizedBox(height: 25),

                        const Center(
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 29,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Don’t worry! Enter your registered email address. We will send you a 4-digit OTP to verify your identity.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 35),

                        const Text(
                          'Email Address',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your registered email',
                            hintStyle: const TextStyle(
                              color: Color(0xFF8A94A6),
                              fontSize: 13,
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: blue,
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF5F8FC),
                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: const BorderSide(
                                color: Color(0xFFDCE5F0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: const BorderSide(
                                color: Color(0xFFDCE5F0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: const BorderSide(
                                color: blue,
                                width: 1.5,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Please enter your email';
                            }

                            if (!RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            ).hasMatch(value.trim())) {
                              return 'Enter a valid email address';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF8A00),
                                  Color(0xFFFF5A00),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : _continueToOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                disabledBackgroundColor:
                                    Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Continue to OTP Verification',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Remember your password? ',
                                style: TextStyle(
                                  color: mutedColor,
                                  fontSize: 12,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        const Center(
                          child: Text(
                            'SECURE ACCESS  •  BUSISERVE INFOTECH SOLUTION',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF8A94A6),
                              fontSize: 9,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowOrb(double size, Color color) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: 0.10),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
