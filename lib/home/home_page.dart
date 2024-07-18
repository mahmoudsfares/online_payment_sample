import 'package:flutter/material.dart';
import 'package:online_payment_sample/home/home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController _controller = HomeController();

  HomePage({super.key});

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
                          Future.delayed(Duration.zero, () => Navigator.pushNamed(context, '/payment', arguments: paymentTokenResponse));
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
