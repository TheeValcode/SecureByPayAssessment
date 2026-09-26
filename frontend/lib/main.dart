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
      return DashboardScreen(
        onLogout: () {
          auth.logout();
          setState(() {
            isLogin = true;
          });
        },
      );
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
                  padding: const EdgeInsets.only(left: 64.0, right: 64.0, bottom: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLogin
                            ? 'Monitor your shipments from Nigeria! Enjoy swift delivery and\nseamless customs processing'
                            : 'Access global markets with our quick shipping from Nigeria! Fast\ndelivery and easy customs to 300+ countries.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.85),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
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
                          final messenger = ScaffoldMessenger.of(context);
                          final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
                          final emailText = _emailController.text.trim();
                          final success = await auth.signUp(
                            fullName: fullName,
                            email: emailText,
                            password: _passwordController.text,
                            phoneNumber: _phoneController.text.trim(),
                          );
                          if (success) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Registration successful! Welcome to Myafrimall.'),
                                backgroundColor: Color(0xFF10B981),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
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

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onLogout;
  const DashboardScreen({super.key, this.onLogout});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String _selectedPeriod = 'Year';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.03),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;
        final isMobile = constraints.maxWidth < 600;

        Widget sidebarContent = Container(
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
                    backgroundColor: Colors.transparent,
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
                onTap: () {
                  if (widget.onLogout != null) {
                    widget.onLogout!();
                  } else {
                    auth.logout();
                  }
                },
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
        );

        Widget mainContent = FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : (isDesktop ? 40 : 24),
                vertical: isMobile ? 20 : 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Header
                  Text(
                    'Invite & Earn',
                    style: GoogleFonts.inter(
                      fontSize: isMobile ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A202C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Keep track of your addresses, location updates. Edit, Delete, Update and see all your invited addresses',
                    style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF718096)),
                  ),
                  const SizedBox(height: 24),

                  // Hero Banner Card with world_map_bg on the right
                  Container(
                    height: isMobile ? 150 : 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B243B),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 20 : 40,
                            vertical: isMobile ? 20 : 36,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'KEEP UP WITH YOUR\nBUSINESS NEEDS',
                                style: GoogleFonts.inter(
                                  fontSize: isMobile ? 20 : 28,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  height: 1.2,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isMobile)
                          Positioned(
                            right: 20,
                            top: 10,
                            bottom: 10,
                            child: Image.asset(
                              'assets/images/world_map_bg.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Carousel Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCarouselDot(false),
                      const SizedBox(width: 6),
                      _buildCarouselDot(true),
                      const SizedBox(width: 6),
                      _buildCarouselDot(false),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Overview Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Overview',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A202C),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'This Month',
                              style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF4A5568)),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF718096)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Overview Metric Cards Row (Responsive Grid / Flex)
                  _buildResponsiveOverview(isDesktop, isMobile),
                  const SizedBox(height: 32),

                  // Recent Shipment Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent shipment',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A202C),
                        ),
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        onPressed: () {},
                        child: Text(
                          'See All',
                          style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF718096)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Company Growth Chart Card
                  Container(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Company Growth',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A202C),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(3),
                              child: Row(
                                children: [
                                  _buildPeriodTab('Year'),
                                  _buildPeriodTab('Month'),
                                  _buildPeriodTab('Week'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 220,
                          width: double.infinity,
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return CustomPaint(
                                painter: CompanyGrowthChartPainter(
                                  animationProgress: _animationController.value,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Shipment List Cards
                  _buildShipmentCard(
                    trackingId: 'MAF-100-234-291',
                    sender: 'Bunmi Tonny',
                    receiver: 'Mercy',
                    pickup: 'Lagos, Nigeria',
                    delivery: 'Oyo, Nigeria',
                    amount: '₦3000',
                    status: 'In-Transit',
                    statusBg: const Color(0xFFFEF3C7),
                    statusColor: const Color(0xFFD97706),
                    processingTime: '10 hours',
                    actionButton: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Paid',
                        style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B), fontWeight: FontWeight.w600),
                      ),
                    ),
                    isMobile: isMobile,
                  ),
                  const SizedBox(height: 16),
                  _buildShipmentCard(
                    trackingId: 'MAF-100-234-291',
                    sender: 'Bunmi Tonny',
                    receiver: 'Mercy',
                    pickup: 'Lagos, Nigeria',
                    delivery: 'Oyo, Nigeria',
                    amount: '₦3000',
                    status: 'Delayed',
                    statusBg: const Color(0xFFCFFAFE),
                    statusColor: const Color(0xFF0891B2),
                    processingTime: '10 hours',
                    actionButton: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B3648),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: Text(
                        'Pay Now',
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    isMobile: isMobile,
                  ),
                  const SizedBox(height: 16),
                  _buildShipmentCardHeaderOnly(
                    trackingId: 'MAF-100-234-291',
                    sender: 'Bunmi Tonny',
                    receiver: 'Mercy',
                    isMobile: isMobile,
                  ),
                ],
              ),
            ),
          ),
        );

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: !isDesktop
              ? AppBar(
                  title: Text('Myafrimall', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                  backgroundColor: Colors.white,
                  elevation: 1,
                  iconTheme: const IconThemeData(color: Color(0xFF2B3648)),
                )
              : null,
          drawer: !isDesktop ? Drawer(child: sidebarContent) : null,
          body: Row(
            children: [
              if (isDesktop) sidebarContent,
              Expanded(child: mainContent),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResponsiveOverview(bool isDesktop, bool isMobile) {
    final balanceCard = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF5B67CA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your balance',
            style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 11),
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
              foregroundColor: const Color(0xFF5B67CA),
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
    );

    final shipmentCard = _buildMetricCard(
      iconBg: const Color(0xFFFEF3C7),
      icon: Icons.local_shipping_outlined,
      iconColor: const Color(0xFFD97706),
      title: 'Total Shipment',
      count: '34',
      percentage: '90%',
    );

    final exportsCard = _buildMetricCard(
      iconBg: const Color(0xFFD1FAE5),
      icon: Icons.arrow_upward,
      iconColor: const Color(0xFF059669),
      title: 'Total Exports',
      count: '34',
      percentage: '90%',
    );

    final importsCard = _buildMetricCard(
      iconBg: const Color(0xFFE0F2FE),
      icon: Icons.arrow_downward,
      iconColor: const Color(0xFF0284C7),
      title: 'Total Imports',
      count: '34',
      percentage: '90%',
    );

    if (isDesktop) {
      return Row(
        children: [
          Expanded(flex: 3, child: balanceCard),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: shipmentCard),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: exportsCard),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: importsCard),
        ],
      );
    } else {
      return Column(
        children: [
          balanceCard,
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: shipmentCard),
              const SizedBox(width: 12),
              Expanded(child: exportsCard),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: importsCard),
              const SizedBox(width: 12),
              const Spacer(),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildCarouselDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? const Color(0xFF5B67CA) : const Color(0xFFCBD5E1),
      ),
    );
  }

  Widget _buildPeriodTab(String label) {
    final isSelected = _selectedPeriod == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1))]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF64748B),
          ),
        ),
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

  Widget _buildMetricCard({
    required Color iconBg,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String count,
    required String percentage,
  }) {
    return _HoverCard(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16, color: iconColor),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.inter(color: const Color(0xFF718096), fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  count,
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A202C),
                  ),
                ),
                const SizedBox(width: 6),
                Row(
                  children: [
                    const Icon(Icons.arrow_upward, size: 12, color: Color(0xFF16A34A)),
                    Text(
                      percentage,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'vs last month ↑',
              style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFFA0AEC0)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentCard({
    required String trackingId,
    required String sender,
    required String receiver,
    required String pickup,
    required String delivery,
    required String amount,
    required String status,
    required Color statusBg,
    required Color statusColor,
    required String processingTime,
    required Widget actionButton,
    bool isMobile = false,
  }) {
    final pickupWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pick Up From', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
        const SizedBox(height: 4),
        Row(
          children: [
            Image.asset(
              'assets/images/twemoji_flag-nigeria.png',
              width: 18,
              height: 18,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 6),
            Text(pickup, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B))),
          ],
        ),
      ],
    );

    final deliveryWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Delivery To', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
        const SizedBox(height: 4),
        Row(
          children: [
            Image.asset(
              'assets/images/twemoji_flag-nigeria.png',
              width: 18,
              height: 18,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 6),
            Text(delivery, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B))),
          ],
        ),
      ],
    );

    final amountWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Amount', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
        const SizedBox(height: 4),
        Text(amount, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF1E293B))),
      ],
    );

    final statusWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Status', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
          ),
        ),
      ],
    );

    return _HoverCard(
      child: Container(
        padding: EdgeInsets.all(isMobile ? 14 : 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tracking ID', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                      const SizedBox(height: 2),
                      Text(
                        trackingId,
                        style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF4C51BF)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sender', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                      const SizedBox(height: 2),
                      Text(sender, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B))),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Receiver', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                      const SizedBox(height: 2),
                      Text(receiver, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B))),
                    ],
                  ),
                ),
                const Icon(Icons.keyboard_arrow_up, color: Color(0xFF64748B)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: Color(0xFFF1F5F9), height: 1),
            ),
            // Details row
            if (isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [pickupWidget, deliveryWidget],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [amountWidget, statusWidget],
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 3, child: pickupWidget),
                  Expanded(flex: 3, child: deliveryWidget),
                  Expanded(flex: 2, child: amountWidget),
                  statusWidget,
                ],
              ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(color: Color(0xFFF1F5F9), height: 1),
            ),
            // Action & processing time row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Processing Time', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 16, color: Color(0xFF64748B)),
                        const SizedBox(width: 6),
                        Text(processingTime, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF475569))),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: () {},
                      child: Text(
                        'View More',
                        style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF475569), fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 12),
                    actionButton,
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentCardHeaderOnly({
    required String trackingId,
    required String sender,
    required String receiver,
    bool isMobile = false,
  }) {
    return _HoverCard(
      child: Container(
        padding: EdgeInsets.all(isMobile ? 14 : 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tracking ID', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                  const SizedBox(height: 2),
                  Text(
                    trackingId,
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF4C51BF)),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sender', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                  const SizedBox(height: 2),
                  Text(sender, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B))),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Receiver', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF94A3B8))),
                  const SizedBox(height: 2),
                  Text(receiver, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B))),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_up, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }
}

class _HoverCard extends StatefulWidget {
  final Widget child;
  const _HoverCard({required this.child});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        transform: _isHovered
            ? (Matrix4.identity()..translate(0.0, -4.0, 0.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}

class CompanyGrowthChartPainter extends CustomPainter {
  final double animationProgress;

  CompanyGrowthChartPainter({this.animationProgress = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..strokeWidth = 1.0;

    final textStyle = GoogleFonts.inter(fontSize: 10, color: const Color(0xFF94A3B8));

    // Y-Axis labels and grid lines
    final yLabels = ['100%', '80%', '60%', '40%', '20%', '0'];
    final chartHeight = size.height - 30;
    final chartWidth = size.width - 40;
    const leftPadding = 35.0;

    for (int i = 0; i < yLabels.length; i++) {
      final y = (chartHeight / (yLabels.length - 1)) * i;
      canvas.drawLine(Offset(leftPadding, y), Offset(leftPadding + chartWidth, y), gridPaint);

      final textSpan = TextSpan(text: yLabels[i], style: textStyle);
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 6));
    }

    // X-Axis labels
    for (int i = 1; i <= 12; i++) {
      final x = leftPadding + (chartWidth / 11) * (i - 1);
      final textSpan = TextSpan(text: '$i', style: textStyle);
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - 3, chartHeight + 8));
    }

    // Data points matching the wave line in Figma
    final points = [
      Offset(leftPadding + (chartWidth / 11) * 0, chartHeight * 0.72),
      Offset(leftPadding + (chartWidth / 11) * 1, chartHeight * 0.68),
      Offset(leftPadding + (chartWidth / 11) * 2, chartHeight * 0.70),
      Offset(leftPadding + (chartWidth / 11) * 3, chartHeight * 0.65),
      Offset(leftPadding + (chartWidth / 11) * 4, chartHeight * 0.67),
      Offset(leftPadding + (chartWidth / 11) * 5, chartHeight * 0.55),
      Offset(leftPadding + (chartWidth / 11) * 6, chartHeight * 0.60),
      Offset(leftPadding + (chartWidth / 11) * 7, chartHeight * 0.50),
      Offset(leftPadding + (chartWidth / 11) * 8, chartHeight * 0.58),
      Offset(leftPadding + (chartWidth / 11) * 9, chartHeight * 0.38),
      Offset(leftPadding + (chartWidth / 11) * 10, chartHeight * 0.92),
      Offset(leftPadding + (chartWidth / 11) * 11, chartHeight * 0.08),
    ];

    final maxCount = (points.length * animationProgress).clamp(1.0, points.length.toDouble()).floor();

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < maxCount - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p1.dx, p1.dy);
    }

    // Gradient fill under path
    final fillPath = Path.from(path);
    if (maxCount > 1) {
      fillPath.lineTo(points[maxCount - 1].dx, chartHeight);
      fillPath.lineTo(leftPadding, chartHeight);
      fillPath.close();

      final fillGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF5A67D8).withOpacity(0.2),
          const Color(0xFF5A67D8).withOpacity(0.0),
        ],
      );

      final fillPaint = Paint()
        ..shader = fillGradient.createShader(Rect.fromLTRB(leftPadding, 0, leftPadding + chartWidth, chartHeight));

      canvas.drawPath(fillPath, fillPaint);
    }

    // Stroke line
    final linePaint = Paint()
      ..color = const Color(0xFF4C51BF)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CompanyGrowthChartPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress;
  }
}
