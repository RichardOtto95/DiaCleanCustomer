import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:diaclean_customer/app/core/modules/splash/splash_store.dart';
import 'package:flutter/material.dart';

import '../../../shared/utilities.dart';

class SplashPage extends StatefulWidget {
  final String title;
  const SplashPage({Key? key, this.title = 'SplashPage'}) : super(key: key);
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final SplashStore store = Modular.get();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth _auth = FirebaseAuth.instance;
      Future.delayed(Duration(seconds: 4), () {
        User? _user = _auth.currentUser;
        if (_user == null) {
          Modular.to.pushReplacementNamed('/sign-phone');
        } else {
          Modular.to.pushReplacementNamed('/main');
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     "briteness::: ${MediaQueryData.fromWindow(WidgetsBinding.instance.window).platformBrightness}");
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(
        MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                    .platformBrightness ==
                Brightness.light
            ? getColors(context).surface
            : getColors(context).secondary,
      ),
      child: Scaffold(
        backgroundColor: WidgetsBinding.instance.window.platformBrightness ==
                Brightness.light
            ? getColors(context).surface
            : getColors(context).secondary,
        body: Container(
          padding: EdgeInsets.symmetric(vertical: wXD(100, context)),
          alignment: Alignment.center,
          child: Image.asset(
            brightness == Brightness.light
                ? "./assets/images/logo.png"
                : "./assets/images/logo_dark.png",
            fit: BoxFit.fitHeight,
            width: wXD(119, context),
            height: wXD(122, context),
          ),
        ),
      ),
    );
  }
}
