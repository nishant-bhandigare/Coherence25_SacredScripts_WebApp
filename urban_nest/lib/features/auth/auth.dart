import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:urban_nest/responsive_layout.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _rememberMe = false;
  bool _isLoginMode = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: _buildLoginForm(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(flex: 1, child: _buildBackgroundDesign()),
        Expanded(
          flex: 1,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(width: 400, child: _buildLoginForm()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundDesign() {
    return Container(
      color: const Color(0xFF4A6CF7),
      child: const Center(
        child: Icon(
          FontAwesomeIcons.gamepad,
          size: 200,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Icon(
            FontAwesomeIcons.gamepad,
            size: 100,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _isLoginMode ? 'Welcome Back!' : 'Create an Account',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),

        // Conditional fields based on login/signup mode
        if (!_isLoginMode) _buildNameField(),
        if (!_isLoginMode) const SizedBox(height: 20),

        _buildEmailField(),
        const SizedBox(height: 20),
        _buildPasswordField(),

        if (!_isLoginMode) const SizedBox(height: 20),
        if (!_isLoginMode) _buildConfirmPasswordField(),

        const SizedBox(height: 10),

        // Remember me only in login mode
        if (_isLoginMode) _buildRememberMeAndForgotPassword(),

        const SizedBox(height: 20),
        _buildPrimaryActionButton(),
        const SizedBox(height: 20),

        // Alternative login only in login mode
        if (_isLoginMode) _buildAlternativeLogin(),

        const SizedBox(height: 20),
        _buildModeTogglePrompt(),
      ],
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Full Name',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: const Icon(Icons.visibility_off),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextField(
      controller: _confirmPasswordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: const Icon(Icons.visibility_off),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (bool? value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
            ),
            const Text('Remember Me'),
          ],
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Forgot Password feature coming soon')),
            );
          },
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: Color(0xFF4A6CF7)),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryActionButton() {
    return ElevatedButton(
      onPressed: _isLoginMode ? _performLogin : _performSignUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4A6CF7),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
          _isLoginMode ? 'Login' : 'Sign Up',
          style: const TextStyle(fontSize: 16)
      ),
    );
  }

  Widget _buildAlternativeLogin() {
    return Column(
      children: [
        const Text('Or'),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Google Login coming soon')),
            );
          },
          icon: const Icon(Icons.login),
          label: const Text('Login with Google'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildModeTogglePrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_isLoginMode
            ? 'Don\'t have an account?'
            : 'Already have an account?'
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isLoginMode = !_isLoginMode;
            });
          },
          child: Text(
            _isLoginMode ? 'Create here' : 'Login',
            style: const TextStyle(color: Color(0xFF4A6CF7)),
          ),
        ),
      ],
    );
  }

  void _performLogin() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    // Placeholder for login logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Logging in with ${_emailController.text}')),
    );
  }

  void _performSignUp() {
    // Validate signup fields
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Check password match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Placeholder for signup logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Signing up ${_nameController.text} with ${_emailController.text}')),
    );

    // Optionally switch to login mode after successful signup
    setState(() {
      _isLoginMode = true;
    });
  }
}