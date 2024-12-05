import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.I;

@InjectableInit(preferRelativeImports: true)
Future<void> setupDI() async => getIt.init();