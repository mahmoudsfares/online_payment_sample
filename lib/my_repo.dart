import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:online_payment_sample/constants.dart';

class MyRepo {

  Future<String> payWithPaymob(int amount) async {
    try {
      String token = await _getToken();
      int orderId = await _getOrderId(token: token, amount: (100 * amount).toString());
      String paymentKey = await _getPaymentKey(token: token, orderId: orderId.toString(), amount: (100 * amount).toString());
      return paymentKey;
    } catch(e) {
      print('Error occurred');
      rethrow;
    }
  }

  // TODO 3: prepare the methods that will be called to invoke the api flow
  Future<String> _getToken() async {
    Uri uri = Uri.https('accept.paymob.com', '/api/auth/tokens');
    String body = jsonEncode({"api_key": Constants.API_KEY});
    http.Response response = await http.post(uri, body: body, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<int> _getOrderId({required String token, required String amount}) async {
    Uri uri = Uri.https('accept.paymob.com', '/api/ecommerce/orders');
    String body = jsonEncode({
      "auth_token": token,
      "delivery_needed": "true",
      "amount_cents": amount,
      "currency": "EGP",
      "items": [],
    });
    http.Response response = await http.post(uri, body: body, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      return jsonDecode(response.body)['id'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> _getPaymentKey({required String token, required String orderId, required String amount}) async {
    Uri uri = Uri.https('accept.paymob.com', '/api/acceptance/payment_keys');
    String body = jsonEncode({
      "auth_token": token,
      "order_id": orderId,
      "amount_cents": amount,
      "currency": "EGP",
      "integration_id": "4612417", // payment channel id, it can be found in the payment integrations page under development in your accept account
      "expiration": 3600, // the expiration time of this payment token in seconds.
      // all the fields are mandatory, the fields than aren't available can be set to "NA" except for first_name, last_name, email, and phone_number
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
      }
    });
    http.Response response = await http.post(uri, body: body, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}
