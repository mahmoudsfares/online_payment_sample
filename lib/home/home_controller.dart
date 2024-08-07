import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:online_payment_sample/constants.dart';

class HomeController {

  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  // TODO 3: prepare the api call for getting the payment key
  // url: https://accept.paymob.com/v1/intention/
  // get the payment methods ids from developers -> payment integrations
  // all the NA data in billing data are not required
  // for the expected 201 response, head to response section:
  // https://developers.paymob.com/egypt/checkout-api/integration-guide-and-api-reference/create-intention-payment-api
  Future<String> _getPaymentKey(String amount) async {
    Uri uri = Uri.https("accept.paymob.com", "/v1/intention/");
    String body = jsonEncode({
      "amount": amount,
      "currency": "EGP",
      "items": [],
      "payment_methods": [4612417],
      "billing_data": {
        "apartment": "NA",
        "email": "me@email.com",
        "floor": "NA",
        "first_name": "Mahmoud",
        "street": "NA",
        "building": "NA",
        "phone_number": "+201234567890",
        "shipping_method": "NA",
        "postal_code": "NA",
        "city": "NA",
        "country": "NA",
        "last_name": "Fares",
        "state": "NA"
      },
    });
    http.Response response = await http.post(uri, body: body, headers: {"Content-Type": "application/json", "Authorization": Constants.SECRET_KEY});
    if (response.statusCode == 201) {
      Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
      List<dynamic> paymentKeys = body["payment_keys"] as List<dynamic>;
      Map<String, dynamic> integration = paymentKeys[0] as Map<String, dynamic>;
      String paymentKey = integration["key"];
      return paymentKey;
    } else {
      throw Exception('Failed to get token');
    }
  }

  // TODO 4: create a high-level method that will call all the methods created in step 3 in order
  // provided amount is in cents so it must be multiplied by 100
  Future<String> payWithPaymob(int amount) async {
    try {
      isLoading.value = true;
      String token = await _getPaymentKey((100 * amount).toString());
      isLoading.value = false;
      return token;
    } catch (e) {
      isLoading.value = false;
      return 'FAILED: ${e.toString().substring(11)}';
    }
  }
}
