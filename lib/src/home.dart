import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_razor_pay/src/provider/payment_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _razorpay = Razorpay();
  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Toast.show("Payment Successful !!",
        duration: Toast.lengthLong, gravity: Toast.bottom);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Toast.show("Payment Failed !!",
        duration: Toast.lengthLong, gravity: Toast.bottom);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Toast.show("External Wallet !!",
        duration: Toast.lengthLong, gravity: Toast.bottom);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _payProvider = Provider.of<PaymentProvider>(context);
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: LottieBuilder.asset('assets/lotties/avatar.json'),
        ),
        title: Text(
          'Razor Pay',
          style: GoogleFonts.gabriela(
            letterSpacing: 5.0,
            fontSize: 22,
          ),
        ),
      ),
      body: _payProvider.isLoading
          ? Center(
              child: LottieBuilder.asset('assets/lotties/loading.json'),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.8,
                  child:
                      LottieBuilder.asset('assets/lotties/payment_cards.json'),
                ),
                Text(
                  "₹${_payProvider.payAmount}",
                  style: GoogleFonts.gabriela(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbColor: const Color(0xFFEB1555),
                    activeTrackColor: const Color(0xFFEB1555),
                    inactiveTrackColor: const Color(0xFF8D8E98),
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 15.0),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 30.0),
                    overlayColor: const Color(0x55EB1555),
                  ),
                  child: Slider(
                    // activeColor: Colors.pink[500],
                    value: _payProvider.payAmount,
                    max: 100,
                    divisions: 5,
                    label: _payProvider.payAmount.round().toString(),
                    onChanged: (double value) {
                      _payProvider.payAmount = value;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(18.0),
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () async {
                      _payProvider.isLoading = true;
                      await Future.delayed(const Duration(seconds: 3));
                      _paymentCheckOut(amount: _payProvider.payAmount.toInt());
                      _payProvider.isLoading = false;
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 15.0,
                    ),
                    child: Text(
                      'Pay',
                      style: GoogleFonts.gabriela(
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  _paymentCheckOut({required int amount}) {
    var options = {
      'key': 'rzp_test_zanm3tdBXmSHF6',
      'amount': amount * 100,
      'name': 'Justin Roy',
      'description': 'Razor Payment Testing',
      'prefill': {
        'contact': '9142377402',
        'email': 'roysunny951@gmail.com',
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }
}
