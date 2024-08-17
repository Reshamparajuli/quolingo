import 'dart:ui'; // Import for blur effect

import 'package:finalproject/app/storage/shared_preferences.dart';
import 'package:finalproject/core/widgets/custom_dialogue.dart';
import 'package:finalproject/features/auth/presentation/view/login_view.dart';
import 'package:finalproject/features/home/data/model/shake_detector.dart';
import 'package:finalproject/features/home/presentation/navigator/home_navigator.dart';
import 'package:finalproject/features/practice/presentation/view/practice_view.dart';
import 'package:finalproject/features/pricing/presentation/view/pricing_view.dart';
import 'package:finalproject/features/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _selectedIndex = 0;
  late ShakeDetector _shakeDetector;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePageContent(),
    PricingView(),
    PracticeTaskView(),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _shakeDetector = ShakeDetector(onPhoneShake: _handleLogout);
    _shakeDetector.startListening();
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    super.dispose();
  }

  void _handleLogout() {
    Vibration.vibrate();
    // Perform your logout logic here.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('You are going to logout due to shaking the device.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to the LoginScreen and remove all previous routes
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isUserLoggedIn = SharedPref.sharedPref.getBool('isUserLoggedIn') ?? false;
    String userName = SharedPref.sharedPref.getString('userName') ?? '';
    return SafeArea(
      child: Stack(
        children: [
          Container(
            // Background image
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background2.jpg'), // Replace with your background image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Apply blur effect using BackdropFilter
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.4), // Dark overlay to enhance contrast
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent, // Make Scaffold transparent
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Image.asset(
                'assets/images/logo.png',
                height: 55,
              ),
              centerTitle: false,
              backgroundColor: const Color.fromARGB(0, 106, 106, 53),
              elevation: 20.0,
              shadowColor: Colors.black,
              actions: [
                !isUserLoggedIn
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginView()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color.fromARGB(255, 216, 140, 53),
                        ),
                        child: const Text(
                          'Signup / Login',
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Row(
                          children: [
                            Text(
                              // Display username if logged in
                              'Welcome, $userName',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.logout),
                              onPressed: () {
                                showCustomDialogue(
                                        content: 'please login for more practice questions and subscription',
                                        title: 'Are you sure, you want to logout?',
                                        context: context)
                                    .then((value) async {
                                  if (value) {
                                    SharedPref.sharedPref.setBool('isUserLoggedIn', false);
                                    SharedPref.sharedPref.remove('userName');
                                    SharedPref.sharedPref.remove('email');
                                    context.mounted
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const HomeView()),
                                          )
                                        : null;
                                    context.mounted
                                        ? ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Color(0xFF8E7F55),
                                              content: Text('You have been logged out successfully'),
                                            ),
                                          )
                                        : null;
                                  }
                                });
                              },
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
              ],
            ),
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money),
                  label: 'Pricing',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'Practice',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.amber[800],
              unselectedItemColor: Colors.white,
              onTap: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}

class HomePageContent extends ConsumerWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = ref.watch(homeViewNavigatorProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/logo.png', // Replace with your logo asset
                  height: 200,
                ),
                const Text(
                  'Uplingo\'s Practice Platform',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'The Best Way To Boost Your Score!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Improve your Duolingo English Test score with our unlimited practice platform. '
                  'Start for FREE and begin enhancing your score today.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    navigator.openPracticeView();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 216, 140, 53),
                  ),
                  child: const Text('Get Started'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
