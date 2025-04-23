import 'package:flutter/material.dart';

import 'presentation/routes/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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
