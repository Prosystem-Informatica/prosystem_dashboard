
import 'package:flutter/material.dart';
import 'package:prosystem_dashboard/app/bloc_injector.dart';
import 'package:prosystem_dashboard/app/core/config/application_config.dart';

void main() async {
  await ApplicationConfig().configure();
  runApp(BlocInjection());
}