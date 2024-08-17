import 'package:finalproject/app/app.dart';
import 'package:finalproject/app/storage/shared_preferences.dart';
import 'package:finalproject/core/networking/local/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await HiveService().init();

  await SharedPref.init();
  runApp(
    const ProviderScope(child: App()),
  );
}
