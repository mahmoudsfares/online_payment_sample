import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:online_payment_sample/constants.dart';

class HomeController {

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  ValueNotifier<bool> get isLoading => _isLoading;

  final ValueNotifier<String> _errorMessage = ValueNotifier('');
  ValueNotifier<String> get errorMessage => _errorMessage;

  // TODO 3: prepare the methods that will be called to invoke the api flow
  Future<String> _getToken(String amount) async {
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
      String token = integration["key"];
      return token;
    } else {
      throw Exception('Failed to get token');
    }
  }

  // TODO 4: create a high-level method that will call all the methods created in step 3 in order
  Future<String> payWithPaymob(int amount) async {
    try {
      _isLoading.value = true;
      String token = await _getToken((100 * amount).toString());
      _isLoading.value = false;
      return token;
    } catch (e) {
      _isLoading.value = false;
      _errorMessage.value = 'FAILED: ${e.toString().substring(11)}';
      return 'FAILED: ${e.toString().substring(11)}';
    }
  }
}
