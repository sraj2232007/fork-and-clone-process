import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  static const Color navy = Color(0xFFFFFFFF);
  static const Color blue = Color(0xFF087EFF);
  static const Color orange = Color(0xFFFF6B00);
  static const Color textColor = Color(0xFF071A36);
  static const Color mutedColor = Color(0xFF718096);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login function
  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Login UI is ready. Firebase authentication is not connected yet.',
        ),
        backgroundColor: Color(0xFF071A36),
      ),
    );
  }

  // Navigate to Signup Screen
  void _openSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  // Navigate to Forgot Password Screen
  void _openForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // White background with subtle gradient
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

          // Blue decorative glow
          Positioned(
            top: -100,
            right: -100,
            child: _glowOrb(250, blue),
          ),

          // Orange decorative glow
          Positioned(
            bottom: -120,
            left: -120,
            child: _glowOrb(280, orange),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo and branding
                        Center(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/busiserve_logo.png',
                                width: 170,
                                height: 130,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
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
                                  color: Color(0xFF071A36),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 35),

                        // Welcome heading
                        const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 9),

                        const Text(
                          'Sign in to continue to your BusiServe account.',
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 30),

                        _fieldLabel('Email Address'),

                        const SizedBox(height: 10),

                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                          ),
                          decoration: _inputDecoration(
                            hint: 'Enter your email address',
                            icon: Icons.email_outlined,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
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

                        const SizedBox(height: 23),

                        _fieldLabel('Password'),

                        const SizedBox(height: 10),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(
                            color: textColor,
                            fontSize: 14,
                          ),
                          decoration: _inputDecoration(
                            hint: 'Enter your password',
                            icon: Icons.lock_outline_rounded,
                          ).copyWith(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: mutedColor,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }

                            if (value.length < 6) {
                              return 'Password must have at least 6 characters';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        // Remember me and Forgot Password
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _rememberMe,
                                activeColor: blue,
                                checkColor: Colors.white,
                                side: const BorderSide(
                                  color: Color(0xFF9BAEC9),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(width: 7),

                            const Text(
                              'Remember me',
                              style: TextStyle(
                                color: mutedColor,
                                fontSize: 12,
                              ),
                            ),

                            const Spacer(),

                            TextButton(
                              onPressed: _openForgotPassword,
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 27),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF087EFF),
                                  Color(0xFF00AEEF),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: blue.withValues(alpha: 0.20),
                                  blurRadius: 18,
                                  offset: const Offset(0, 7),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                disabledBackgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 23,
                                      height: 23,
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
                                          'Sign In',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 26),

                        // Divider
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Color(0xFFDCE5F0),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 13),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: mutedColor,
                                  fontSize: 11,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Color(0xFFDCE5F0),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Create Account - Navigate to Signup Screen
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Flexible(
                              child: Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: mutedColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: _openSignup,
                              child: const Text(
                                'Create Account',
                                style: TextStyle(
                                  color: orange,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 35),

                        // Footer
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

  // Decorative glow
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

  // Field label
  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF071A36),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Input decoration
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF8A94A6),
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF087EFF),
        size: 20,
      ),
      filled: true,
      fillColor: const Color(0xFFF5F8FC),
      contentPadding: const EdgeInsets.symmetric(
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
          color: Color(0xFF087EFF),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(
          color: Color(0xFFE53935),
        ),
      ),
    );
  }
}
