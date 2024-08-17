import 'dart:convert';

import 'package:finalproject/app/constants/shared_pref_constants.dart';
import 'package:finalproject/app/storage/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class CountdownTimer extends StatefulWidget {
  final DateTime expirationDate;

  const CountdownTimer({super.key, required this.expirationDate});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.expirationDate.difference(DateTime.now());
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime = widget.expirationDate.difference(DateTime.now());
        if (remainingTime.isNegative) {
          timer.cancel();
          remainingTime = Duration.zero;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    return '$days days $hours hrs $minutes min $seconds sec';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(remainingTime),
      style: const TextStyle(fontSize: 16, color: Colors.red),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  List<Map<String, dynamic>> cardList = [];

  @override
  void initState() {
    super.initState();
    _loadCardList();
  }

  Future<void> _loadCardList() async {
    List<String> cards = await getCardList();
    setState(() {
      cardList = cards.map((card) {
        try {
          return jsonDecode(card) as Map<String, dynamic>;
        } catch (e) {
          return {"card": card, "expirationDate": "N/A"};
        }
      }).toList();
    });
  }

  Future<List<String>> getCardList() async {
    return SharedPref.sharedPref.getStringList(Constants.pricingCardValue) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final String userName = SharedPref.sharedPref.getString(Constants.userName) ?? '';
    final bool isUserLoggedIn = SharedPref.sharedPref.getBool(Constants.isUserLoggedIn) ?? false;

    return Scaffold(
      body: isUserLoggedIn
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            {"icon": Icons.person, "title": userName},
                          ]
                              .asMap()
                              .map(
                                (index, e) => MapEntry(
                                  index,
                                  Row(
                                    children: [
                                      Icon(
                                        e["icon"] as IconData,
                                        size: 24,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        e["title"] as String,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .values
                              .toList(),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Subscription plan:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    cardList.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cardList.length,
                            itemBuilder: (context, index) {
                              String cardName = cardList[index]["card"];
                              String expirationDateStr = cardList[index]["expirationDate"];
                              DateTime expirationDate;
                              bool isValidDate = true;

                              try {
                                expirationDate = DateTime.parse(expirationDateStr);
                              } catch (e) {
                                expirationDate = DateTime.now();
                                isValidDate = false;
                              }

                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text(
                                    cardName,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  subtitle: isValidDate
                                      ? Row(
                                          children: [
                                            const Flexible(
                                              child: Text(
                                                'Expires on:',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Flexible(child: CountdownTimer(expirationDate: expirationDate)),
                                          ],
                                        )
                                      : const Text("Invalid expiration date"),
                                ),
                              );
                            },
                          )
                        : const Text(
                            'No Subscriptions....',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                  ],
                ),
              ),
            )
          : const ProfileViewWithNotLoggedIn(),
    );
  }
}

class ProfileViewWithNotLoggedIn extends StatelessWidget {
  const ProfileViewWithNotLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            textAlign: TextAlign.center,
            'Please login to view your profile and Subscriptions',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
