import 'package:diaclean_customer/app/core/services/auth/auth_store.dart';
import 'package:diaclean_customer/app/modules/sign_phone/sign_phone_store.dart';
import 'package:diaclean_customer/app/shared/utilities.dart';
import 'package:diaclean_customer/app/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../shared/color_theme.dart';

class SignPagePhone extends StatefulWidget {
  const SignPagePhone({Key? key}) : super(key: key);

  @override
  _SignPagePhoneState createState() => _SignPagePhoneState();
}

class _SignPagePhoneState extends State<SignPagePhone> {
  final SignPhoneStore store = Modular.get();
  final AuthStore authStore = Modular.get();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();

  MaskTextInputFormatter maskFormatterPhone = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});

  String phone = '';
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(getColors(context).secondary),
      child: Listener(
        onPointerDown: (a) => FocusScope.of(context).requestFocus(FocusNode()),
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
              backgroundColor: getColors(context).secondary,
              body: PageView(
                children: [
                  Observer(builder: (context) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        SvgPicture.asset(
                          "./assets/svg/logo-diaclean-dark.svg",
                          height: wXD(134, context),
                          width: wXD(223, context),
                        ),
                        // Image.asset(
                        //   brightness == Brightness.light
                        //       ? "./assets/images/logo.png"
                        //       : "./assets/svg/logo-diaclean-dark.svg",
                        //   width: wXD(173, context),
                        //   height: wXD(153, context),
                        // ),
                        // const Spacer(),
                        // Text(
                        //   'Entrar em sua conta',
                        //   textAlign: TextAlign.center,
                        //   style: textFamily(
                        //     context,
                        //     fontSize: 28,
                        //     color: getColors(context).onBackground,
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        // ),
                        const Spacer(flex: 2),
                        Container(
                          // height: wXD(42, context),
                          width: wXD(224, context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(23)),
                            color: getColors(context).primary,
                          ),

                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: wXD(20, context),
                                vertical: wXD(13, context)),
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                inputFormatters: [maskFormatterPhone],
                                keyboardType: TextInputType.phone,
                                cursorColor: darkPurple,
                                decoration: InputDecoration.collapsed(
                                    hintText: 'Telefone',
                                    hintStyle: textFamily(
                                      context,
                                      fontSize: 16,
                                      color: getColors(context)
                                          .onPrimary
                                          .withOpacity(.6),
                                    )),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                style: textFamily(
                                  context,
                                  fontSize: 16,
                                  color: getColors(context).onPrimary,
                                ),
                                onChanged: (val) {
                                  print(
                                      'val: ${maskFormatterPhone.unmaskText(val)} - ${maskFormatterPhone.unmaskText(val).length}');
                                  phone = maskFormatterPhone.unmaskText(val);
                                  store.setPhone(phone);
                                },
                                validator: (value) {
                                  if (value != null) {
                                    print(
                                        'value validator: $value ${value.length}');
                                  }
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor preenchar o número de telefone';
                                  }
                                  if (value.length < 15) {
                                    return 'Preencha com todos os números';
                                  }
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  if (_formKey.currentState!.validate()) {
                                    if (store.phone == null) {
                                      store.phone = phone;
                                    }
                                    // print('store.start: ${store.getResendingSMSSeconds}');
                                    print(
                                        'store.start: ${store.resendingSeconds}');
                                    // if (store.getResendingSMSSeconds != 60 &&
                                    //     store.getResendingSMSSeconds != 0) {
                                    if (store.resendingSeconds != 60 &&
                                        store.resendingSeconds != 0) {
                                      Fluttertoast.showToast(
                                        // msg:"Aguarde ${store.getResendingSMSSeconds} segundos para reenviar um novo código",
                                        msg:
                                            "Aguarde ${store.resendingSeconds} segundos para reenviar um novo código",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    } else {
                                      store.verifyNumber(context);
                                    }
                                  }
                                },
                                controller: _phoneNumberController,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 1),
                        Observer(
                          builder: (context) => store.resendingSeconds != 0
                              ? Text(
                                  // "Aguarde ${store.getResendingSMSSeconds} segundos para reenviar um novo código",
                                  "Aguarde ${store.resendingSeconds} segundos para reenviar um novo código",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal),
                                )
                              : Container(),
                        ),
                        const Spacer(flex: 1),
                        PrimaryButton(
                          color: darkPurple,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              if (phone.length < 11) {
                                showToast("Preencha o campo corretamente");
                                return;
                              }
                              if (store.phone == null) {
                                store.phone = phone;
                              }
                              // print('store.resendingSMSSeconds: ${store.getResendingSMSSeconds}');
                              print(
                                  'store.resendingSMSSeconds: ${store.resendingSeconds}');

                              // if (store.getResendingSMSSeconds != 0) {
                              if (store.resendingSeconds != 0) {
                                Fluttertoast.showToast(
                                  // msg: "Aguarde ${store.getResendingSMSSeconds} segundos para reenviar um novo código",
                                  msg:
                                      "Aguarde ${store.resendingSeconds} segundos para reenviar um novo código",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: getColors(context).error,
                                  textColor: getColors(context).onError,
                                  fontSize: 16.0,
                                );
                              } else {
                                store.verifyNumber(context);
                              }
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
                    );
                  }),
                ],
              )),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return AnnotatedRegion<SystemUiOverlayStyle>(
  //     value: getOverlayStyleFromColor(getColors(context).background),
  //     child: Listener(
  //       onPointerDown: (a) =>
  //           FocusScope.of(context).requestFocus(new FocusNode()),
  //       child: WillPopScope(
  //         onWillPop: () async => false,
  //         child: Scaffold(
  //           backgroundColor: getColors(context).background,
  //           body: Observer(builder: (context) {
  //             return SingleChildScrollView(
  //               child: Container(
  //                 height: maxHeight(context),
  //                 width: maxWidth(context),
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Spacer(),
  //                     Stack(
  //                       children: [
  //                         SizedBox(
  //                           width: maxWidth(context),
  //                           child: Image.asset(
  //                             brightness == Brightness.light
  //                                 ? "./assets/images/logo.png"
  //                                 : "./assets/images/logo_dark.png",
  //                             width: wXD(173, context),
  //                             height: wXD(153, context),
  //                           ),
  //                         ),
  //                         Positioned(
  //                           top: 0,
  //                           right: wXD(20, context),
  //                           child: IconButton(
  //                             onPressed: () {
  //                               Modular.to.pushNamed("/support");
  //                             },
  //                             icon: Icon(
  //                               Icons.contact_support_outlined,
  //                               size: wXD(40, context),
  //                               color: getColors(context).primary,
  //                             ),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                     Spacer(),
  //                     Text(
  //                       'Bem vindo',
  //                       textAlign: TextAlign.center,
  //                       style: textFamily(
  //                         context,
  //                         fontSize: 28,
  //                         color: getColors(context).onBackground,
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                     ),
  //                     Text(
  //                       'Cadastre-se para entrar',
  //                       textAlign: TextAlign.center,
  //                       style: textFamily(
  //                         context,
  //                         fontSize: 20,
  //                         color: getColors(context).onBackground,
  //                         fontWeight: FontWeight.w400,
  //                       ),
  //                     ),
  //                     Spacer(flex: 2),
  //                     Container(
  //                       width: wXD(235, context),
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           GestureDetector(
  //                             onTap: () => focusNode.requestFocus(),
  //                             child: Text(
  //                               'Telefone',
  //                               style: textFamily(
  //                                 context,
  //                                 fontSize: 20,
  //                                 color: getColors(context)
  //                                     .onBackground
  //                                     .withOpacity(.5),
  //                                 fontWeight: FontWeight.w400,
  //                               ),
  //                             ),
  //                           ),
  //                           Form(
  //                             key: _formKey,
  //                             child: TextFormField(
  //                               focusNode: focusNode,
  //                               inputFormatters: [maskFormatterPhone],
  //                               keyboardType: TextInputType.phone,
  //                               autovalidateMode:
  //                                   AutovalidateMode.onUserInteraction,
  //                               style: textFamily(context, fontSize: 20),
  //                               decoration: InputDecoration.collapsed(
  //                                 hintText: '',
  //                               ),
  //                               onChanged: (val) {
  //                                 print(
  //                                     'val: ${maskFormatterPhone.unmaskText(val)} - ${maskFormatterPhone.unmaskText(val).length}');
  //                                 phone = maskFormatterPhone.unmaskText(val);
  //                                 store.setPhone(phone);
  //                               },
  //                               validator: (value) {
  //                                 print('value validator: $value');
  //                                 if (value == null || value.isEmpty) {
  //                                   return 'Campo obrigatório';
  //                                 }
  //                                 if (value.length < 15) {
  //                                   return 'Campo incompleto';
  //                                 }

  //                                 return null;
  //                               },
  //                               onEditingComplete: () {
  //                                 FocusScope.of(context)
  //                                     .requestFocus(new FocusNode());
  //                                 if (_formKey.currentState!.validate()) {
  //                                   if (store.phone == null) {
  //                                     store.phone = phone;
  //                                   }
  //                                   // print('store.start: ${store.getResendingSMSSeconds}');
  //                                   print(
  //                                       'store.start: ${store.resendingSeconds}');
  //                                   // if (store.getResendingSMSSeconds != 60 &&
  //                                   //     store.getResendingSMSSeconds != 0) {
  //                                   if (store.resendingSeconds != 60 &&
  //                                       store.resendingSeconds != 0) {
  //                                     Fluttertoast.showToast(
  //                                       // msg:"Aguarde ${store.getResendingSMSSeconds} segundos para reenviar um novo código",
  //                                       msg:
  //                                           "Aguarde ${store.resendingSeconds} segundos para reenviar um novo código",
  //                                       toastLength: Toast.LENGTH_SHORT,
  //                                       gravity: ToastGravity.BOTTOM,
  //                                       timeInSecForIosWeb: 1,
  //                                       backgroundColor: Colors.red,
  //                                       textColor: Colors.white,
  //                                       fontSize: 16.0,
  //                                     );
  //                                   } else {
  //                                     store.verifyNumber(context);
  //                                   }
  //                                 }
  //                               },
  //                               controller: _phoneNumberController,
  //                             ),
  //                           ),
  //                           Container(
  //                             decoration: BoxDecoration(
  //                               border: Border(
  //                                 bottom: BorderSide(
  //                                     color: getColors(context).primary),
  //                               ),
  //                             ),
  //                           ),
  //                           // SizedBox(
  //                           //   height: wXD(20, context),
  //                           // ),
  //                           // Center(
  //                           //   child: GestureDetector(
  //                           //     onTap: () async {
  //                           //       _phoneNumberController.clear();
  //                           //       store.setPhone(null);
  //                           //       phone = '';
  //                           //       await Modular.to.pushNamed('/sign-email');
  //                           //     },
  //                           //     child: Stack(
  //                           //       alignment: Alignment.center,
  //                           //       children: [
  //                           //         Positioned(
  //                           //           left: 0,
  //                           //           child: Icon(Icons.email_outlined),
  //                           //         ),
  //                           //         Container(
  //                           //           width: wXD(160, context),
  //                           //           alignment: Alignment.center,
  //                           //           child: Text("Logar com email",
  //                           //               style: textFamily(context,)),
  //                           //         )
  //                           //       ],
  //                           //     ),
  //                           //   ),
  //                           // )
  //                         ],
  //                       ),
  //                     ),
  //                     Spacer(flex: 1),
  //                     Observer(
  //                       name: "resendingSMSSeconds",
  //                       // builder: (context) => store.getResendingSMSSeconds != 0
  //                       builder: (context) => store.resendingSeconds != 0
  //                           ? Text(
  //                               // "Aguarde ${store.getResendingSMSSeconds} segundos para reenviar um novo código",
  //                               "Aguarde ${store.resendingSeconds} segundos para reenviar um novo código",
  //                               style: TextStyle(
  //                                   fontSize: 13,
  //                                   fontWeight: FontWeight.normal),
  //                             )
  //                           : Container(),
  //                     ),
  //                     Spacer(flex: 1),
  //                     PrimaryButton(
  //                       onTap: () {
  //                         if (_formKey.currentState!.validate()) {
  //                           FocusScope.of(context)
  //                               .requestFocus(new FocusNode());
  //                           if (phone.length < 11) {
  //                             showToast("Preencha o campo corretamente");
  //                             return;
  //                           }
  //                           if (store.phone == null) {
  //                             store.phone = phone;
  //                           }
  //                           // print('store.resendingSMSSeconds: ${store.getResendingSMSSeconds}');
  //                           print(
  //                               'store.resendingSMSSeconds: ${store.resendingSeconds}');

  //                           // if (store.getResendingSMSSeconds != 0) {
  //                           if (store.resendingSeconds != 0) {
  //                             Fluttertoast.showToast(
  //                               // msg: "Aguarde ${store.getResendingSMSSeconds} segundos para reenviar um novo código",
  //                               msg:
  //                                   "Aguarde ${store.resendingSeconds} segundos para reenviar um novo código",
  //                               toastLength: Toast.LENGTH_SHORT,
  //                               gravity: ToastGravity.BOTTOM,
  //                               timeInSecForIosWeb: 1,
  //                               backgroundColor: getColors(context).error,
  //                               textColor: getColors(context).onError,
  //                               fontSize: 16.0,
  //                             );
  //                           } else {
  //                             store.verifyNumber(context);
  //                           }
  //                         }
  //                       },
  //                       title: 'Entrar',
  //                       height: wXD(52, context),
  //                       width: wXD(142, context),
  //                     ),
  //                     Spacer(),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           }),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
