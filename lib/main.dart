import 'package:flutter/material.dart';

import 'app.dart';
import 'core/state/hacksim_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = await HackSimController.create();
  runApp(HackSimApp(controller: controller));
}
