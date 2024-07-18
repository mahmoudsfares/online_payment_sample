import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController webViewController = WebViewController();
  late final String paymentKey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    paymentKey = ModalRoute.of(context)!.settings.arguments as String;
    webViewController.loadRequest(Uri.parse('https://accept.paymob.com/api/acceptance/iframes/856537?payment_token=$paymentKey'));
  }

  @override
  Widget build(BuildContext context) {
    print('https://accept.paymob.com/api/acceptance/iframes/856537?payment_token=$paymentKey');
    return Scaffold(
        body: SafeArea(child: WebViewWidget(controller: webViewController)),
    );
  }
}
