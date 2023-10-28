import 'package:diaclean_customer/app/core/services/auth/auth_store.dart';
import 'package:diaclean_customer/app/modules/sign_phone/sign_phone_store.dart';
import 'package:diaclean_customer/app/shared/color_theme.dart';
import 'package:diaclean_customer/app/shared/utilities.dart';
import 'package:diaclean_customer/app/shared/widgets/default_app_bar.dart';
import 'package:diaclean_customer/app/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'custom_pincode_textfield.dart';

class Verify extends StatefulWidget {
  final String phoneNumber;
  const Verify({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  final SignPhoneStore store = Modular.get();
  final AuthStore authStore = Modular.get();
  final TextEditingController _pinCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('onWillPo verify');
        if (store.loadOverlay != null) {
          if (store.loadOverlay!.mounted) {
            return false;
          }
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: getColors(context).secondary,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                SvgPicture.asset(
                  "./assets/svg/logo-diaclean-dark.svg",
                  height: wXD(134, context),
                  width: wXD(223, context),
                ),
                const Spacer(flex: 2),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: wXD(30, context)),
                  width: maxWidth(context),
                  child: CustomPinCodeTextField(controller: _pinCodeController),
                ),
                const Spacer(flex: 1),
                Observer(
                  builder: (context) => store.resendingSeconds != 0
                      ? Text(
                          "Aguarde ${store.resendingSeconds} segundos para reenviar um novo código",
                          style: textFamily(
                            context,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        )
                      : TextButton(
                          child: Text(
                            'Reenviar o código',
                            style: textFamily(
                              context,
                              color: Colors.white.withOpacity(.75),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          onPressed: () {
                            store.resendingSMS(context);
                          },
                        ),
                ),
                const Spacer(flex: 1),
                PrimaryButton(
                  color: darkPurple,
                  onTap: () async {
                    print(
                        '_pinCodeController.text: ${_pinCodeController.text.isNotEmpty} - ${_pinCodeController.text.length}');
                    if (_pinCodeController.text.length == 6 &&
                        _pinCodeController.text.isNotEmpty) {
                      await store.signinPhone(
                        _pinCodeController.text,
                        context,
                      );
                    } else {
                      showErrorToast(context, "Código incompleto!");
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Entrar",
                        style: textFamily(
                          context,
                          color: getColors(context).onPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: wXD(2, context)),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: wXD(18, context),
                        color: getColors(context).onPrimary,
                      )
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
            Positioned(
              top: viewPaddingTop(context) + wXD(10, context),
              left: wXD(15, context),
              child: IconButton(
                onPressed: () {
                  Modular.to.pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: wXD(23, context),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return WillPopScope(
  //     onWillPop: () async {
  //       print('onWillPo verify');
  //       if (store.loadOverlay != null) {
  //         if (store.loadOverlay!.mounted) {
  //           return false;
  //         }
  //       }
  //       return true;
  //     },
  //     child: Scaffold(
  //       backgroundColor: getColors(context).background,
  //       body: Stack(
  //         children: [
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Spacer(flex: 6),
  //               Text(
  //                 'Insira o código enviado para o \n número ${phoneMask.maskText(widget.phoneNumber)}',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: 14, height: 1.5),
  //               ),
  //               Spacer(flex: 2),
  //               Container(
  //                 margin: EdgeInsets.symmetric(horizontal: wXD(30, context)),
  //                 width: maxWidth(context),
  //                 child: CustomPinCodeTextField(controller: _pinCodeController),
  //               ),
  //               Spacer(
  //                 flex: 2,
  //               ),
  //               Observer(builder: (context) {
  //                 return store.resendingSeconds != 0
  //                     ? Text(
  //                         "Aguarde ${store.resendingSeconds} segundos para reenviar um novo código",
  //                         style: TextStyle(
  //                           fontSize: 13,
  //                           fontWeight: FontWeight.normal,
  //                         ),
  //                       )
  //                     : TextButton(
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             border: Border(
  //                                 bottom: BorderSide(
  //                                     color: getColors(context).secondary,
  //                                     width: 2)),
  //                           ),
  //                           padding: EdgeInsets.only(bottom: wXD(3, context)),
  //                           child: Text(
  //                             'Reenviar o código',
  //                             style: textFamily(
  //                               context,
  //                               color: getColors(context).onBackground,
  //                               fontWeight: FontWeight.w400,
  //                               fontSize: 15,
  //                             ),
  //                           ),
  //                         ),
  //                         onPressed: () {
  //                           store.resendingSMS(context);
  //                         },
  //                       );
  //               }),
  //               Spacer(flex: 2),
  //               PrimaryButton(
  //                 onTap: () async {
  //                   if (_pinCodeController.text.length == 6 &&
  //                       _pinCodeController.text.isNotEmpty) {
  //                     await store.signinPhone(
  //                       _pinCodeController.text,
  //                       // authStore.userVerifyId!,
  //                       context,
  //                     );
  //                   } else {
  //                     Fluttertoast.showToast(
  //                         msg: "Código incompleto!",
  //                         toastLength: Toast.LENGTH_SHORT,
  //                         gravity: ToastGravity.BOTTOM,
  //                         timeInSecForIosWeb: 1,
  //                         backgroundColor: getColors(context).error,
  //                         textColor: getColors(context).onError,
  //                         fontSize: 16.0);
  //                   }
  //                 },
  //                 title: 'Validar',
  //                 height: wXD(52, context),
  //                 width: wXD(142, context),
  //               ),
  //               Spacer(),
  //             ],
  //           ),
  //           DefaultAppBar(
  //             'Código enviado',
  //             onPop: () {
  //               print('onWillPo verify');
  //               if (store.loadOverlay == null) {
  //                 Modular.to.pop();
  //               } else if (!store.loadOverlay!.mounted) {
  //                 Modular.to.pop();
  //               }
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  showToast(message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: color,
    );
  }
}
