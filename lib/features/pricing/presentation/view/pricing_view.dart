import 'dart:convert';

import 'package:finalproject/app/constants/shared_pref_constants.dart';
import 'package:finalproject/app/storage/shared_preferences.dart';
import 'package:finalproject/core/models/esewa_payment.dart';
import 'package:finalproject/features/auth/presentation/view/login_view.dart';
import 'package:finalproject/features/practice/presentation/view/practice_view.dart';
import 'package:finalproject/features/pricing/presentation/state/pricing_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PricingView extends ConsumerWidget {
  const PricingView({super.key});

  Future<void> addCardToList(String card, int days) async {
    List<String> cardList = SharedPref.sharedPref.getStringList(Constants.pricingCardValue) ?? [];
    DateTime expirationDate = DateTime.now().add(Duration(days: days));

    Map<String, dynamic> cardInfo = {
      "card": card,
      "expirationDate": expirationDate.toIso8601String(),
    };
    cardList.add(jsonEncode(cardInfo));
    await SharedPref.sharedPref.setStringList(Constants.pricingCardValue, cardList);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pricingNotifier = ref.read(pricingNotifierProvider.notifier);
    bool isUserLoggedIn = SharedPref.sharedPref.getBool('isUserLoggedIn') ?? false;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Start your practice for free!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'For unlimited Practice Questions, Upgrade to Premium.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    _buildPricingCard(context, 'Free Questions', Icons.question_answer, 'Get Started', onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PracticeTaskView()),
                      );
                    }),
                    const SizedBox(height: 20),
                    _buildPricingCard(context, 'Unlimited Access\n7 Days', Icons.workspace_premium_outlined, 'Upgrade',
                        price: 'NPR 1099', onPressed: () async {
                      if (!isUserLoggedIn) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginView()),
                        );
                        return;
                      }
                      await PayWithEsewa.makePayment('1099');
                      _showSuccessDialog(context, 'Payment Successful',
                          'You have successfully purchased Unlimited Access for 7 Days.');
                      addCardToList('Unlimited Access 7 Days', 7);
                    }),
                    const SizedBox(height: 20),
                    _buildPricingCard(context, 'Unlimited Access\n15 Days', Icons.workspace_premium_outlined, 'Upgrade',
                        price: 'NPR 1499', onPressed: () async {
                      if (!isUserLoggedIn) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginView()),
                        );
                        return;
                      }
                      await PayWithEsewa.makePayment('1499');
                      _showSuccessDialog(context, 'Payment Successful',
                          'You have successfully purchased Unlimited Access for 15 Days.');
                      // ignore: avoid_print
                      print('Unlimited Access 15 Days');
                      addCardToList('Unlimited Access 15 Days', 15);
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPricingCard(
    BuildContext context,
    String title,
    IconData icon,
    String buttonText, {
    String? price,
    required VoidCallback onPressed,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: const Color.fromARGB(255, 43, 36, 46).withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.amber,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            if (price != null) ...[
              const SizedBox(height: 10),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.amber,
                ),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 216, 140, 53),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
