
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = true;
  bool _isLoading = false;

  static const Color navy = Color(0xFF071A36);
  static const Color blue = Color(0xFF087EFF);
  static const Color orange = Color(0xFFFF6B00);
  static const Color muted = Color(0xFF718096);

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updatePasswordStrength);
  }

  void _updatePasswordStrength() {
    if (mounted) setState(() {});
  }

  int get _passwordStrength {
    final password = _passwordController.text;
    int score = 0;

    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) score++;

    return score;
  }

  String get _strengthText {
    if (_passwordController.text.isEmpty) return 'Enter a password';
    if (_passwordStrength <= 1) return 'Weak password';
    if (_passwordStrength == 2) return 'Medium password';
    if (_passwordStrength == 3) return 'Good password';
    return 'Strong password';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.removeListener(_updatePasswordStrength);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFF8A94A6),
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF58B7FF),
        size: 20,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF5F8FC),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFDCE5F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFDCE5F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: blue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: navy,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _field({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    Widget? suffix,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool obscure = false,
    TextCapitalization capitalization = TextCapitalization.none,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: capitalization,
          obscureText: obscure,
          validator: validator,
          style: const TextStyle(
            color: navy,
            fontSize: 14,
          ),
          decoration: _decoration(
            hint: hint,
            icon: icon,
            suffix: suffix,
          ),
        ),
      ],
    );
  }

  Widget _passwordStrengthIndicator() {
    final score = _passwordStrength;

    final Color strengthColor = score <= 1
        ? Colors.redAccent
        : score == 2
            ? orange
            : score == 3
                ? Colors.lightGreen
                : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: index < score
                      ? strengthColor
                      : const Color(0xFFE5E8EF),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            Icon(
              Icons.shield_rounded,
              color: strengthColor,
              size: 13,
            ),
            const SizedBox(width: 5),
            Text(
              _strengthText,
              style: TextStyle(
                color: strengthColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Text(
              'Minimum 8 characters',
              style: TextStyle(color: muted, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }

  Widget _socialButton({
    required Widget icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFDCE5F0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: navy,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept Terms and Conditions.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Connect Firebase Authentication or your backend API here.

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Signup UI is ready. Authentication is not connected yet.',
        ),
        backgroundColor: navy,
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Same white gradient as Login Screen
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

          // Blue glow
          Positioned(
            top: -100,
            right: -100,
            child: _glowOrb(250, blue),
          ),

          // Orange glow
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
                                  color: navy,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 35),

                        // Heading
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            color: navy,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 9),

                        const Text(
                          'Create your BusiServe account to get started.',
                          style: TextStyle(
                            color: muted,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Full name
                        _field(
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          icon: Icons.person_outline_rounded,
                          controller: _nameController,
                          capitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 22),

                        // Email
                        _field(
                          label: 'Email Address',
                          hint: 'Enter your email address',
                          icon: Icons.email_outlined,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                    .hasMatch(value.trim())) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 22),

                        // Phone
                        _label('Phone Number'),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F8FC),
                                borderRadius: BorderRadius.circular(13),
                                border: Border.all(
                                  color: const Color(0xFFDCE5F0),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Text('🇮🇳'),
                                  SizedBox(width: 5),
                                  Text(
                                    '+91',
                                    style: TextStyle(
                                      color: navy,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_down, size: 18),
                                ],
                              ),
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                style: const TextStyle(
                                  color: navy,
                                  fontSize: 14,
                                ),
                                decoration: _decoration(
                                  hint: 'Phone number',
                                  icon: Icons.phone_outlined,
                                ).copyWith(counterText: ''),
                                validator: (value) {
                                  if (value == null ||
                                      !RegExp(r'^[0-9]{10}$')
                                          .hasMatch(value.trim())) {
                                    return 'Enter valid 10-digit number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // Password
                        _field(
                          label: 'Password',
                          hint: 'Create a strong password',
                          icon: Icons.lock_outline_rounded,
                          controller: _passwordController,
                          obscure: _obscurePassword,
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: muted,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 8) {
                              return 'Minimum 8 characters required';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        _passwordStrengthIndicator(),

                        const SizedBox(height: 22),

                        // Confirm password
                        _field(
                          label: 'Confirm Password',
                          hint: 'Re-enter your password',
                          icon: Icons.lock_reset_rounded,
                          controller: _confirmPasswordController,
                          obscure: _obscureConfirmPassword,
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: muted,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        // Terms and conditions
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _agreeToTerms,
                                activeColor: blue,
                                onChanged: (value) {
                                  setState(() {
                                    _agreeToTerms = value ?? false;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 7),
                            const Expanded(
                              child: Text(
                                'I agree to the Terms & Conditions and Privacy Policy.',
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 27),

                        // Orange gradient Create Account button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFF8A00),
                                  Color(0xFFFF5A1F),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: orange.withValues(alpha: 0.20),
                                  blurRadius: 18,
                                  offset: const Offset(0, 7),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed:
                                  _isLoading ? null : _createAccount,
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
                                          'Create Account',
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

                        // OR divider
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
                                  color: muted,
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

                        // Social signup
                        Row(
                          children: [
                            _socialButton(
                              icon: const Text(
                                'G',
                                style: TextStyle(
                                  color: Color(0xFF4285F4),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              text: 'Google',
                              onPressed: () => _showMessage(
                                'Google Sign-In will be connected later.',
                              ),
                            ),
                            const SizedBox(width: 12),
                            _socialButton(
                              icon: const Icon(
                                Icons.window_rounded,
                                color: blue,
                                size: 19,
                              ),
                              text: 'Microsoft',
                              onPressed: () => _showMessage(
                                'Microsoft Sign-In will be connected later.',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 26),

                        // Login navigation
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Flexible(
                              child: Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                final navigator = Navigator.of(context);
                                if (navigator.canPop()) {
                                  navigator.pop();
                                } else {
                                  navigator.pushReplacementNamed('/login');
                                }
                              },
                              child: const Text(
                                'Sign In',
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
}
