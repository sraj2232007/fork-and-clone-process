
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  State<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState
    extends State<OtpVerificationScreen> {
  final TextEditingController _otpController =
      TextEditingController();

  final FocusNode _otpFocusNode = FocusNode();

  Timer? _timer;

  int _remainingSeconds = 59;

  bool _isLoading = false;
  bool _useSms = false;

  static const Color navy = Color(0xFF092D70);
  static const Color darkNavy = Color(0xFF071A36);
  static const Color orange = Color(0xFFFF762E);
  static const Color muted = Color(0xFF718096);
  static const Color lightBackground = Color(0xFFF8F7FF);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _remainingSeconds = 59;
    });

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) return;

        if (_remainingSeconds > 0) {
          setState(() {
            _remainingSeconds--;
          });
        } else {
          timer.cancel();
        }
      },
    );
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60)
        .toString()
        .padLeft(2, '0');

    final seconds = (_remainingSeconds % 60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  String get _maskedEmail {
    final parts = widget.email.split('@');

    if (parts.length != 2 || parts[0].isEmpty) {
      return widget.email;
    }

    final username = parts[0];
    final visible = username.length > 2
        ? username.substring(0, 2)
        : username.substring(0, 1);

    return '$visible${'*' * (username.length - visible.length)}@${parts[1]}';
  }

  void _verifyOtp() async {
    if (_otpController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 4-digit OTP.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Connect your real OTP verification API here.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'OTP UI is ready. Connect your authentication backend to verify the code.',
        ),
        backgroundColor: navy,
      ),
    );
  }

  void _resendOtp() {
    if (_remainingSeconds > 0) return;

    _otpController.clear();
    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Resend UI is ready. Connect your backend to send a new OTP.',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFAF9FF),
                  Color(0xFFF5F4FF),
                  Color(0xFFFCFAFF),
                ],
              ),
            ),
          ),

          // Decorative glows
          Positioned(
            top: 100,
            left: -90,
            child: _glowOrb(210, orange),
          ),

          Positioned(
            top: 140,
            right: -90,
            child: _glowOrb(200, navy),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: navy,
                          size: 21,
                        ),
                      ),

                      const Spacer(),

                      const Text(
                        'BusiServe OTP Verification',
                        style: TextStyle(
                          color: navy,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Spacer(),

                      const Icon(
                        Icons.account_circle_rounded,
                        color: navy,
                        size: 27,
                      ),

                      const SizedBox(width: 12),
                    ],
                  ),
                ),

                const Divider(
                  color: Color(0xFFE6E5F0),
                  height: 1,
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 430,
                        ),
                        child: Column(
                          children: [
                            // Step indicator
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEFF),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Text(
                                '●  Step 2 of 3: Identity Confirmation',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            // Email verification illustration
                            Container(
                              width: 112,
                              height: 112,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 78,
                                    height: 78,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFE9EDFA),
                                      shape: BoxShape.circle,
                                    ),
                                  ),

                                  const Icon(
                                    Icons.mark_email_read_rounded,
                                    size: 43,
                                    color: navy,
                                  ),

                                  Positioned(
                                    bottom: 15,
                                    right: 17,
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: const BoxDecoration(
                                        color: orange,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.verified_rounded,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Security badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF3FF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified_user_rounded,
                                    color: navy,
                                    size: 12,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Enterprise 256-Bit Verification',
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Heading
                            const Text(
                              'Check your inbox',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: darkNavy,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 9),

                            Text(
                              'We have sent a 4-digit verification code to ${_useSms ? 'your registered mobile number' : _maskedEmail}. Please enter it below.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: muted,
                                fontSize: 12,
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Edit email
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.edit_rounded,
                                    color: navy,
                                    size: 13,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'Edit email',
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 22),

                            // OTP input boxes
                            GestureDetector(
                              onTap: () {
                                _otpFocusNode.requestFocus();
                              },
                              child: SizedBox(
                                height: 55,
                                child: Stack(
                                  children: [
                                    Row(
                                      children: List.generate(
                                        4,
                                        (index) {
                                          final otp =
                                              _otpController.text;

                                          final digit =
                                              index < otp.length
                                                  ? otp[index]
                                                  : '';

                                          final isActive =
                                              index == otp.length &&
                                              otp.length < 4;

                                          return Expanded(
                                            child: Container(
                                              height: 54,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                                border: Border.all(
                                                  color: isActive
                                                      ? orange
                                                      : const Color(
                                                          0xFFE3E6F2,
                                                        ),
                                                  width: isActive ? 1.5 : 1,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: navy.withValues(
                                                      alpha: 0.03,
                                                    ),
                                                    blurRadius: 8,
                                                  ),
                                                ],
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                digit.isEmpty && isActive
                                                    ? '|'
                                                    : digit,
                                                style: TextStyle(
                                                  color: digit.isEmpty
                                                      ? orange
                                                      : navy,
                                                  fontSize: 23,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    // Hidden input captures all digits
                                    Positioned.fill(
                                      child: Opacity(
                                        opacity: 0.01,
                                        child: TextField(
                                          controller: _otpController,
                                          focusNode: _otpFocusNode,
                                          keyboardType:
                                              TextInputType.number,
                                          maxLength: 4,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(
                                              4,
                                            ),
                                          ],
                                          decoration:
                                              const InputDecoration(
                                            counterText: '',
                                            border: InputBorder.none,
                                          ),
                                          onChanged: (_) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.flash_on_rounded,
                                  color: orange,
                                  size: 13,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Auto-submit on completion',
                                  style: TextStyle(
                                    color: muted,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Resend timer card
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 13,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: navy.withValues(alpha: 0.035),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.hourglass_bottom_rounded,
                                        color: orange,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'Resend code in ',
                                        style: TextStyle(
                                          color: muted,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        _formattedTime,
                                        style: const TextStyle(
                                          color: navy,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 6),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Didn't receive code? ",
                                        style: TextStyle(
                                          color: muted,
                                          fontSize: 10,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _resendOtp,
                                        child: Text(
                                          'Resend Code',
                                          style: TextStyle(
                                            color: _remainingSeconds == 0
                                                ? orange
                                                : const Color(0xFFB0B5C3),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 17),

                            // Verify button
                            SizedBox(
                              width: double.infinity,
                              height: 49,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF812F),
                                      Color(0xFFFFA900),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(11),
                                  boxShadow: [
                                    BoxShadow(
                                      color: orange.withValues(alpha: 0.20),
                                      blurRadius: 12,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : _verifyOtp,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    disabledBackgroundColor:
                                        Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(11),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 21,
                                          width: 21,
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
                                              'Verify & Proceed',
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
                                              size: 19,
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // SMS verification option
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _useSms = !_useSms;
                                  _otpController.clear();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEEEFF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.phone_android_rounded,
                                      color: navy,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      _useSms
                                          ? 'Verify via Email OTP instead'
                                          : 'Verify via SMS OTP instead',
                                      style: const TextStyle(
                                        color: navy,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            // Security footer
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.security_rounded,
                                  color: Color(0xFFA0A5B4),
                                  size: 11,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Secure biometric & keypad sandbox active',
                                  style: TextStyle(
                                    color: Color(0xFFA0A5B4),
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
              color.withValues(alpha: 0.08),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
