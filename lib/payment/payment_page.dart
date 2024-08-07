import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey webViewKey = GlobalKey();
  late final InAppWebViewController webViewController;
  late final String paymentKey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    paymentKey = ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // TODO 5: open the iframe in a web view with the payment key you obtained from step 3
        // check out all the available iframes from developers -> iframes
        child: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: WebUri('https://accept.paymob.com/api/acceptance/iframes/856536?payment_token=$paymentKey')),
          initialSettings: InAppWebViewSettings(transparentBackground: true, safeBrowsingEnabled: true, isFraudulentWebsiteWarningEnabled: true),
          onWebViewCreated: (controller) => webViewController = controller,
        ),
      ),
    );
  }
}
