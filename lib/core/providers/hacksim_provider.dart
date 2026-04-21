import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/hacksim_controller.dart';

final hackSimControllerProvider = ChangeNotifierProvider<HackSimController>((ref) {
  throw StateError('hackSimControllerProvider must be overridden at startup');
});
