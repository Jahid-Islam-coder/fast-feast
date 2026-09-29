import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../../constants/stripe_constants.dart';

enum PaymentMethod { stripe, cod }

class PaymentProvider with ChangeNotifier {
  PaymentMethod _selectedMethod = PaymentMethod.cod;
  bool _isProcessing = false;
  String? _errorMessage;

  PaymentMethod get selectedMethod => _selectedMethod;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;

  void setPaymentMethod(PaymentMethod method) {
    _selectedMethod = method;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> processPayment(double amount) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      switch (_selectedMethod) {
        case PaymentMethod.stripe:
          return await _processStripePayment(amount);
        case PaymentMethod.cod:
          return true; // cod is auto successful at checkout
      }
    } catch (e) {
      debugPrint("Payment error: $e");
      _errorMessage = e.toString();
      return false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<bool> _processStripePayment(double amount) async {
    try {
      debugPrint("Initiating Stripe Payment Sheet for \$$amount");

      // 1. stripe needs amount in cents
      int amountInCents = (amount * 100).round();

      // 2. create payment intent from stripe api
      final paymentIntentData = await _createPaymentIntent(
        amount: amountInCents.toString(),
        currency: StripeConstants.currency,
      );

      if (paymentIntentData == null || paymentIntentData['client_secret'] == null) {
        _errorMessage = paymentIntentData?['error']?['message'] ??
            "Failed to initialize Stripe payment. Please check Stripe API keys.";
        debugPrint("Stripe Payment Intent Error: $_errorMessage");
        return false;
      }

      String clientSecret = paymentIntentData['client_secret'];

      // 3. setup stripe payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: StripeConstants.merchantDisplayName,
          style: ThemeMode.system,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFF644AB5),
            ),
          ),
        ),
      );

      // 4. open payment sheet modal
      await Stripe.instance.presentPaymentSheet();

      debugPrint("Stripe Payment Completed Successfully");
      return true;
    } on StripeException catch (e) {
      debugPrint("Stripe Exception: ${e.error.localizedMessage}");
      if (e.error.code == FailureCode.Canceled) {
        _errorMessage = "Payment was canceled.";
      } else {
        _errorMessage = e.error.localizedMessage ?? "Stripe payment failed.";
      }
      return false;
    } catch (e) {
      debugPrint("Unexpected Stripe Error: $e");
      _errorMessage = "An unexpected error occurred during Stripe payment.";
      return false;
    }
  }

  Future<Map<String, dynamic>?> _createPaymentIntent({
    required String amount,
    required String currency,
  }) async {
    try {
      Map<String, String> body = {
        'amount': amount,
        'currency': currency.toLowerCase(),
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${StripeConstants.secretKey}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      return jsonDecode(response.body);
    } catch (e) {
      debugPrint("Error creating PaymentIntent: $e");
      return null;
    }
  }


}
