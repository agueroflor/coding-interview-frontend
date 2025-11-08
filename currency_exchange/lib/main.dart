import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:currency_exchange/presentation/screens/exchange_screen.dart';
import 'package:currency_exchange/presentation/providers/exchange_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExchangeProvider(),
      child: MaterialApp(
        title: 'Currency Exchange',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const ExchangeScreen(),
      ),
    );
  }
}
