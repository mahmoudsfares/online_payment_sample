import 'package:flutter/material.dart';
import 'package:online_payment_sample/controller.dart';

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final MyController _controller = MyController();

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Online payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ValueListenableBuilder<String>(
              valueListenable: _controller.errorMessage,
              builder: (context, error, child) => Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: _controller.isLoading,
              builder: (context, isLoading, child) => isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        String paymentTokenResponse = await _controller.payWithPaymob(100);
                        if (!paymentTokenResponse.startsWith('FAILED')) {
                          // TODO: go to next page
                        }
                      },
                      child: const Text('Pay now'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
