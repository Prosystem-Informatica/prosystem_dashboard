import 'package:flutter/material.dart';
import 'package:prosystem_dashboard/app/core/helpers/environments.dart';

class ApplicationConfig {
  Future<void> configure() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Environments.load('.env');
  }
}