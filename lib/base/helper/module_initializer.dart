import 'package:async/async.dart';

abstract class ModuleInitializer {
  final AsyncMemoizer<void> _memoizer = AsyncMemoizer<void>();

  Future<void> config();

  Future<void> init() => _memoizer.runOnce(config);
}
