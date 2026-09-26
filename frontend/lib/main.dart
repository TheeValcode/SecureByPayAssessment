import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'responsive_layout.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyafrimallApp(),
    ),
  );
}

class MyafrimallApp extends StatelessWidget {
  const MyafrimallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Myafrimall - Seamless Shipping',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5A67D8),
          primary: const Color(0xFF5A67D8),
          surface: Colors.white,
          background: const Color(0xFFF7FAFC),
        ),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const AuthScreenWrapper(),
    );
  }
}

class AuthScreenWrapper extends StatefulWidget {
  const AuthScreenWrapper({super.key});

  @override
  State<AuthScreenWrapper> createState() => _AuthScreenWrapperState();
}

class _AuthScreenWrapperState extends State<AuthScreenWrapper> {
  bool isLogin = false; // Default to register view per design

  void toggleMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    if (auth.isAuthenticated) {
      return const DashboardScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: ResponsiveLayout(
        mobile: _buildAuthView(context, isMobile: true),
        desktop: _buildAuthView(context, isMobile: false),
      ),
    );
  }

  Widget _buildAuthView(BuildContext context, {required bool isMobile}) {
    if (isMobile) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.03),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey<bool>(isLogin),
              child: AuthFormContent(isLogin: isLogin, onToggle: toggleMode),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        // Left Column: Form Section
        Expanded(
          flex: 5,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 48),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 460),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.03),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: KeyedSubtree(
                    key: ValueKey<bool>(isLogin),
                    child: AuthFormContent(isLogin: isLogin, onToggle: toggleMode),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Right Column: World Map Hero Section
        Expanded(
          flex: 5,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
              return Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: <Widget>[
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              );
            },
            child: SizedBox.expand(
              key: ValueKey<bool>(isLogin),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4C51BF),
                  image: DecorationImage(
                    image: AssetImage(
                      isLogin
                          ? 'assets/images/banner_bg_2.png'
                          : 'assets/images/banner_bg.png',
                    ),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
                child: Container(
                  color: const Color(0xFF4C51BF).withOpacity(0.2),
                  padding: const EdgeInsets.all(64.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLogin
                            ? 'Monitor your shipments from Nigeria! Enjoy swift delivery and\nseamless customs processing'
                            : 'Access global markets with our quick shipping from Nigeria! Fast\ndelivery and easy customs to 300+ countries.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.85),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AuthFormContent extends StatefulWidget {
  final bool isLogin;
  final VoidCallback onToggle;

  const AuthFormContent({
    super.key,
    required this.isLogin,
    required this.onToggle,
  });

  @override
  State<AuthFormContent> createState() => _AuthFormContentState();
}

class _AuthFormContentState extends State<AuthFormContent> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.isLogin ? 'Sign in to your account' : 'Create an account',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 13,
                color: const Color(0xFF718096),
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: widget.isLogin
                      ? "Log in to Myafrimall to enjoy seamless shipping to over 300 countries right from Nigeria. Don't have an account yet? "
                      : "Sign up for Myafrimall and gain unlimited access to shipping to over 300 countries from Nigeria. Do you already have an account? ",
                ),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: widget.onToggle,
                    child: Text(
                      widget.isLogin ? 'Sign Up' : 'Login',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4C51BF),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          if (auth.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      auth.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          if (!widget.isLogin) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('First name'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _firstNameController,
                        decoration: _inputDecoration('John'),
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Last name'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: _inputDecoration('Doe'),
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],

          _buildFieldLabel('Email'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailController,
            decoration: _inputDecoration('user@example.com'),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Enter email';
              if (!val.contains('@')) return 'Invalid email';
              return null;
            },
          ),
          const SizedBox(height: 20),

          if (!widget.isLogin) ...[
            _buildFieldLabel('Phone Number'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _phoneController,
              decoration: _inputDecoration('+234  8012345678'),
            ),
            const SizedBox(height: 20),
          ],

          _buildFieldLabel('Password'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: _inputDecoration('Enter Password').copyWith(
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: const Color(0xFFA0AEC0),
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (val) => val == null || val.isEmpty ? 'Enter password' : null,
          ),

          if (widget.isLogin) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4C51BF),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 28),

          SizedBox(
            width: 160,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A67D8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: auth.isLoading
                  ? null
                  : () async {
                      if (_formKey.currentState!.validate()) {
                        if (widget.isLogin) {
                          await auth.login(
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                          );
                        } else {
                          final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
                          await auth.signUp(
                            fullName: fullName,
                            email: _emailController.text.trim(),
                            password: _passwordController.text,
                            phoneNumber: _phoneController.text.trim(),
                          );
                        }
                      }
                    },
              child: auth.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      widget.isLogin ? 'Login' : 'Create account',
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),

          Wrap(
            children: [
              Text(
                'By clicking on create account you agree to our ',
                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF718096)),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'privacy policy',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4C51BF),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                ' and ',
                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF718096)),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'terms of use',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4C51BF),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF2D3748),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: const Color(0xFFA0AEC0), fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF5A67D8), width: 1.5),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 240,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B3648),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.grid_view_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        'Dashboard',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildNavItem(Icons.local_shipping_outlined, 'Shipments'),
                _buildNavItem(Icons.widgets_outlined, 'Our Services'),
                _buildNavItem(Icons.notifications_none_outlined, 'Notifications'),
                _buildNavItem(Icons.account_balance_wallet_outlined, 'Wallet'),
                _buildNavItem(Icons.location_on_outlined, 'My Addresses'),
                _buildNavItem(Icons.card_giftcard_outlined, 'Invite & Earn'),
                _buildNavItem(Icons.help_outline_rounded, 'Help Center'),
                const Spacer(),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage('assets/images/boxes_globe.png'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        user?.fullName ?? 'Firstname Lastname',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3748),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => auth.logout(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.logout, color: Color(0xFF718096), size: 18),
                        const SizedBox(width: 12),
                        Text(
                          'Logout',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF718096),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main Dashboard Body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Invite & Earn',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A202C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Keep track of your addresses, location updates. Edit, Delete, Update and see all your invited addresses',
                            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF718096)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Hero Banner Card with Box Asset
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A2035),
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/world_map_bg.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'KEEP UP WITH YOUR\nBUSINESS NEEDS',
                              style: GoogleFonts.inter(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.2,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 24,
                          bottom: 0,
                          top: 0,
                          child: Image.asset(
                            'assets/images/boxes_globe.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text(
                    'Overview',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A202C),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Overview Cards Grid
                  Row(
                    children: [
                      // Balance Card
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5A67D8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your balance',
                                style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₦3,000,000.28',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF5A67D8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Fund Wallet',
                                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: _buildStatCard('Total Shipments', '34', '90%')),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: _buildStatCard('Total Exports', '34', '90%')),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: _buildStatCard('Total Imports', '34', '90%')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF718096), size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF4A5568),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, String percentage) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(color: const Color(0xFF718096), fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                count,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A202C),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '↑ $percentage',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
