import 'package:diaclean_customer/app/shared/widgets/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaclean_customer/app/modules/home/home_store.dart';
import 'package:diaclean_customer/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../constants/properties.dart';
import '../../../shared/utilities.dart';

class WasInvited extends StatefulWidget {
  const WasInvited({
    Key? key,
  }) : super(key: key);
  @override
  _WasInvitedState createState() => _WasInvitedState();
}

class _WasInvitedState extends ModularState<WasInvited, HomeStore> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Listener(
        // onPointerDown: (a) =>
        //     FocusScope.of(context).requestFocus(new FocusNode()),
        child: Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: wXD(53, context) + viewPaddingTop(context)),
                  width: maxWidth(context),
                  height: maxHeight(context),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(flex: 2),
                      Image.asset(
                        brightness == Brightness.light
                            ? "./assets/images/logo.png"
                            : "./assets/images/logo_dark.png",
                        width: wXD(173, context),
                        height: wXD(153, context),
                      ),
                      Spacer(),
                      // SizedBox(height: wXD(10, context)),
                      FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('info')
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator(
                                color: getColors(context).primary,
                                backgroundColor:
                                    getColors(context).primary.withOpacity(0.4),
                              );
                            }
                            QuerySnapshot infoQuery = snapshot.data!;
                            DocumentSnapshot infoDoc = infoQuery.docs.first;
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: wXD(30, context)),
                              child: Column(
                                children: [
                                  Text(
                                    // "Algum amigo que te indicou ao Mercado Expresso?",
                                    infoDoc['first_promo_code_screen_title'],
                                    textAlign: TextAlign.center,
                                    style: textFamily(
                                      context,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: getColors(context).onBackground,
                                    ),
                                  ),
                                  SizedBox(height: wXD(18, context)),
                                  Text(
                                    infoDoc[
                                        'first_promo_code_screen_description'],
                                    textAlign: TextAlign.center,
                                    style: textFamily(
                                      context,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: getColors(context).onBackground,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      Spacer(flex: 2),

                      Form(
                        key: _formKey,
                        child: Container(
                          width: maxWidth(context),
                          margin: EdgeInsets.symmetric(
                              horizontal: wXD(30, context)),
                          padding: EdgeInsets.symmetric(
                              horizontal: wXD(11, context),
                              vertical: wXD(18, context)),
                          // height: wXD(200, context),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: getColors(context).primary),
                            borderRadius: defBorderRadius(context),
                          ),
                          child: TextFormField(
                            style: textFamily(
                              context,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration.collapsed(
                                hintText: "Insira o código aqui...",
                                hintStyle: textFamily(context,
                                    fontWeight: FontWeight.w600,
                                    color: getColors(context)
                                        .onBackground
                                        .withOpacity(.3))),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onChanged: (value) {
                              store.promotionalCode = value;
                            },
                            validator: (val) {
                              if (val == null || val == '') {
                                return "Esse campo não pode ser vazio";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                      Spacer(flex: 2),
                      PrimaryButton(
                        title: "Ativar código",
                        onTap: () => store.setWasInvited(true, context),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: wXD(40, context),
                            vertical: wXD(7, context)),
                        child: Text(
                          "Ao ativar o código você ganhará um desconto no valor de R\$ 5,00!",
                          textAlign: TextAlign.center,
                          style: textFamily(
                            context,
                            fontSize: 11,
                            color:
                                getColors(context).onBackground.withOpacity(.5),
                          ),
                        ),
                      ),
                      Spacer(flex: 3),
                    ],
                  ),
                ),
              ),
              DefaultAppBar(
                "Código enviado!",
                onPop: () => store.setWasInvited(false, context),
              ),
              Positioned(
                top: viewPaddingTop(context),
                right: wXD(10, context),
                child: IconButton(
                  onPressed: () => store.setWasInvited(false, context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: getColors(context).primary,
                    size: wXD(30, context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
