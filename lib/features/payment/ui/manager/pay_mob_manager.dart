import 'package:dio/dio.dart';
import 'pay_mob_constants.dart';

class PayMobManager {
  Future<String> getPaymentKey(
      int amount, String currency,String description ) async {
    try {
      String authenticationToken = await _getAuthenticationToken();

      int orderId = await _getOrderId(
        authenticationToken: authenticationToken,
        amount: (100 * amount).toString(),
        currency: currency,
        description: description,
      );

      String paymentKey = await _getPaymentKey(
        authenticationToken: authenticationToken,
        amount: (100 * amount).toString(),
        currency: currency,
        orderId: orderId.toString(),
      );
      return paymentKey;
    } catch (e) {
      print(e.toString());
      throw Exception();
    }
  }

  Future<String> _getAuthenticationToken() async {
    final Response response =
    await Dio().post("https://accept.paymob.com/api/auth/tokens", data: {
      "api_key": payMobApikey,
    });
    return response.data["token"];
  }

  Future<int> _getOrderId({
    required String authenticationToken,
    required String amount,
    required String currency,
    required String description,
  }) async {
    final Response response = await Dio()
        .post("https://accept.paymob.com/api/ecommerce/orders", data: {
      "auth_token": authenticationToken,
      "amount_cents": amount,
      "currency": currency,
      "delivery_needed": "false",
      "items": [
        {
          "name": 'ahmed',
          "amount_cents": '500000',
          "description": description,
          "quantity": '1'
        },
      ],
    });
    
    print('###paymentOrderId###${response.data["id"]}');
    return response.data["id"];
  }

  Future<String> _getPaymentKey({
    required String authenticationToken,
    required String orderId,
    required String amount,
    required String currency,
  }) async {
    final Response response = await Dio()
        .post("https://accept.paymob.com/api/acceptance/payment_keys", data: {
      //ALL OF THEM ARE REQIERD
      "expiration": 3600,

      "auth_token": authenticationToken,
      //From First Api
      "order_id": orderId,
      //From Second Api  >>(STRING)<<
      "integration_id": cardPaymentMethodIntegrationId,
      //Integration Id Of The Payment Method

      "amount_cents": amount,
      "currency": currency,

      "billing_data": {
        //Have To Be Values
        "first_name": "Clifford",
        "last_name": "Nicolas",
        "email": "example@abo.com",
        "phone_number": "+86(8)9135210487",

        //Can Set "NA"
        "apartment": "NA",
        "floor": "NA",
        "street": "NA",
        "building": "NA",
        "shipping_method": "NA",
        "postal_code": "NA",
        "city": "NA",
        "country": "NA",
        "state": "NA"
      },
    });
    return response.data["token"];
  }
}
