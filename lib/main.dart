import 'package:flutter/material.dart';
import 'package:online_payment_sample/home/home_page.dart';
import 'package:online_payment_sample/payment/payment_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => HomePage(),
        '/payment': (context) => PaymentPage(),
      },
    );
  }
}
