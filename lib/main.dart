import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:technical_test/presentation/bloc/bloc_init.dart';

import 'presentation/routes/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('es_ES', null).then((_) {
    runApp(MultiBlocProvider(providers: getListBloc(), child: const MyApp()));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Technical Test',
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
