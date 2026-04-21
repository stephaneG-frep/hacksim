import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/providers/hacksim_provider.dart';
import 'core/state/hacksim_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = await HackSimController.create();
  runApp(
    ProviderScope(
      overrides: [hackSimControllerProvider.overrideWith((ref) => controller)],
      child: const HackSimApp(),
    ),
  );
}
