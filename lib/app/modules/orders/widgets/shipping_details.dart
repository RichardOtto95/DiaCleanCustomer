import 'package:diaclean_customer/app/constants/properties.dart';
import 'package:diaclean_customer/app/shared/widgets/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaclean_customer/app/core/models/order_model.dart';
import 'package:diaclean_customer/app/modules/main/main_store.dart';
import 'package:diaclean_customer/app/modules/orders/widgets/token.dart';
import 'package:diaclean_customer/app/shared/color_theme.dart';
import 'package:diaclean_customer/app/shared/utilities.dart';
import 'package:diaclean_customer/app/shared/widgets/center_load_circular.dart';
import 'package:diaclean_customer/app/shared/widgets/confirm_popup.dart';
import 'package:diaclean_customer/app/shared/widgets/default_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import '../orders_store.dart';
import 'ads_order_data.dart';
import 'status_forecast.dart';

class ShippingDetails extends StatefulWidget {
  final Map<String, dynamic> adsOrderId;

  ShippingDetails({
    Key? key,
    required this.adsOrderId,
  }) : super(key: key);

  @override
  State<ShippingDetails> createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {
  final MainStore mainStore = Modular.get();
  final OrdersStore store = Modular.get();

  @override
  void initState() {
    print('widget.adsOrderId["id"]: ${widget.adsOrderId["id"]}');
    // store.addOrderListener(widget.adsOrderId["id"], context);

    store.zoomPanBehavior = MapZoomPanBehavior(
      // zoomLevel: 13,
      zoomLevel: 5,
      enableDoubleTapZooming: true,
      focalLatLng: MapLatLng(-15.787763, -48.008072),
    );

    store.mapTileLayerController = MapTileLayerController();
    super.initState();
  }

  @override
  void dispose() {
    store.clearShippingDetails();
    // if (store.orderSubs != null) store.orderSubs!.cancel();
    // store.orderSubs = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!store.canBack) {
          return false;
        }
        if (store.overlayCancel != null) {
          if (store.overlayCancel!.mounted) {
            store.overlayCancel!.remove();
            store.overlayCancel = null;
          }
        }
        store.adsId = null;
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  // .collection("customers")
                  // .doc(FirebaseAuth.instance.currentUser!.uid)
                  .collection('orders')
                  .doc(widget.adsOrderId["id"])
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CenterLoadCircular();
                }

                DocumentSnapshot orderDoc = snapshot.data!;
                print('orderDoc.get("agent_id"): ${orderDoc.id}');

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: viewPaddingTop(context) + wXD(60, context)),
                      Observer(builder: (context) {
                        return StatusForecast(
                          status: orderDoc['status'],
                          deliveryForecast: store.deliveryForecast,
                          deliveryForecastLabel: store.deliveryForecastLabel,
                        );
                      }),
                      Container(
                        margin: EdgeInsets.only(top: wXD(20, context)),
                        child: FutureBuilder(
                          future:
                              store.getRoute(widget.adsOrderId["id"], context),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              print(snapshot.error);
                            }

                            if (!snapshot.hasData) {
                              return Container(
                                height: wXD(250, context),
                                width: maxWidth(context),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: getColors(context).primary,
                                  ),
                                ),
                              );
                            }

                            Map<String, dynamic> response =
                                snapshot.data! as Map<String, dynamic>;

                            if (response['status'] == "FAILED") {
                              return Container(
                                height: wXD(250, context),
                                width: maxWidth(context),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Ative as permissões para continuar!",
                                      style: textFamily(
                                        context,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Permission.location.request();
                                      },
                                      child: Text(
                                        "Solicitar permissão",
                                        style: textFamily(
                                          context,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            // Position userCurrentPosition = response['user-current-position'];
                            // _zoomPanBehavior.focalLatLng = MapLatLng(userCurrentPosition.latitude, userCurrentPosition.longitude);
                            return Observer(
                              builder: (context) {
                                return Container(
                                  height: wXD(250, context),
                                  width: maxWidth(context),
                                  child: SfMaps(
                                    layers: [
                                      MapTileLayer(
                                        controller:
                                            store.mapTileLayerController,
                                        urlTemplate:
                                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        zoomPanBehavior: store.zoomPanBehavior,
                                        markerBuilder:
                                            (BuildContext context, int index) {
                                          MapMarker _marker =
                                              store.mapMarkersList[index];
                                          return _marker;
                                        },
                                        initialMarkersCount:
                                            store.mapMarkersList.length,
                                        sublayers: store.polyPoints != []
                                            ? [
                                                MapPolylineLayer(
                                                  polylines: {
                                                    MapPolyline(
                                                      color: Colors.red,
                                                      width: 5,
                                                      points: store.polyPoints
                                                          .map((e) => MapLatLng(
                                                              e.latitude,
                                                              e.longitude))
                                                          .toList(),
                                                    ),
                                                  },
                                                ),
                                              ]
                                            : null,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        width: maxWidth(context),
                        padding: EdgeInsets.symmetric(
                          horizontal: wXD(16, context),
                          vertical: wXD(24, context),
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: getColors(context)
                                    .onBackground
                                    .withOpacity(.2)),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: wXD(25, context),
                                  color: getColors(context).primary,
                                ),
                                SizedBox(width: wXD(12, context)),
                                Observer(builder: (context) {
                                  return Container(
                                    width: wXD(250, context),
                                    child: Text(
                                      store.destinationAddress != null
                                          ? store.destinationAddress!
                                              .formatedAddress!
                                          : "",
                                      style: TextStyle(
                                        color: getColors(context).onBackground,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Token(token: orderDoc['customer_token']),
                      // if (orderDoc.get("agent_id") != null &&
                      //     (orderDoc.get("status") == "DELIVERY_ACCEPTED" ||
                      //         orderDoc.get("status") == "SENDED"))
                      vSpace(10),
                      SendMessage("Falar com diarista", () {
                        Modular.to.pushNamed('/messages/chat', arguments: {
                          "receiverId": orderDoc['agent_id'],
                          "receiverCollection": "agents",
                        });
                      }),
                      SendMessage("Falar com suporte", () {
                        Modular.to.pushNamed('/messages/chat', arguments: {
                          "receiverId": orderDoc['seller_id'],
                          "receiverCollection": "sellers",
                        });
                      }),
                      vSpace(wXD(15, context)),
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                // height: wXD(45, context),
                                width: wXD(220, context),
                                margin: EdgeInsets.only(
                                  right: wXD(5, context),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: wXD(11, context),
                                  horizontal: wXD(12, context),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: defBorderRadius(context),
                                  color: getColors(context).surface,
                                  border: Border.all(
                                      color: getColors(context).primary),
                                ),
                                alignment: Alignment.centerLeft,
                                child: TextField(
                                  decoration: InputDecoration.collapsed(
                                    hintText: "Token",
                                    hintStyle: textFamily(
                                      context,
                                      color: getColors(context)
                                          .onSurface
                                          .withOpacity(.5),
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              PrimaryButton(
                                title: "Validar",
                                onTap: () {},
                                color: darkPurple,
                                fontSize: 13,
                                height: wXD(38, context),
                                width: wXD(91, context),
                              ),
                            ],
                          ),
                          vSpace(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: wXD(14, context),
                                color: getColors(context)
                                    .onSurface
                                    .withOpacity(.5),
                              ),
                              hSpace(wXD(8, context)),
                              Text(
                                "A diarista fornecerá o token para validar o atendimento",
                                style: textFamily(
                                  context,
                                  color: getColors(context)
                                      .onSurface
                                      .withOpacity(.5),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      vSpace(wXD(15, context)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: wXD(32, context),
                                right: wXD(40, context)),
                            child: Column(
                              children: getBools(4, orderDoc['status']),
                            ),
                          ),
                          Observer(builder: (context) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...store.steps.map(
                                  (step) => Step(
                                    title: step['title'],
                                    subTitle: step['sub_title'],
                                    orderStatus: orderDoc['status'],
                                  ),
                                ),
                              ],
                            );
                          })
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: getColors(context)
                                        .onBackground
                                        .withOpacity(.2)))),
                      ),
                      ...widget.adsOrderId["itemsQue"]
                          .map((adsDoc) => AdsOrderData(
                                adsDoc: adsDoc,
                                totalItems: adsDoc["amount"],
                              ))
                          .toList(),
                      if (orderDoc['status'] == "REQUESTED")
                        InkWell(
                          onTap: () {
                            store.overlayCancel = OverlayEntry(
                              builder: (context) => ConfirmPopup(
                                text:
                                    "Tem certeza que deseja cancelar este atendimento?",
                                onConfirm: () async {
                                  await store.cancelOrder(context, orderDoc);
                                  store.overlayCancel!.remove();
                                },
                                onCancel: () => store.overlayCancel!.remove(),
                              ),
                            );
                            Overlay.of(context)!.insert(store.overlayCancel!);
                          },
                          child: Container(
                            width: maxWidth(context),
                            height: wXD(60, context),
                            alignment: Alignment.center,
                            child: Text(
                              "Cancelar",
                              style: textFamily(
                                context,
                                color: red,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      // if (!orderDoc['rated'] &&
                      //     orderDoc['status'] == "CONCLUDED")
                      EvaluateOrderCard(
                          // rating: orderDoc['rating'],
                          rated: orderDoc['rated'],
                          onTap: () {
                            print("store.order!.rated: ${orderDoc['rated']}");
                            if (!orderDoc['rated'])
                              Modular.to.pushNamed(
                                '/orders/evaluation',
                                arguments: Order.fromDoc(orderDoc),
                              );
                          })
                    ],
                  ),
                );
              },
            ),
            DefaultAppBar(
              'Detalhes do atendimento',
              onPop: () {
                store.adsId = null;
                Modular.to.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getBools(int steps, String status) {
    int step = 0;
    switch (status) {
      case "REQUESTED":
        step = 0;
        break;
      case "TIMEOUT":
        step = 1;
        break;
      case "PROCESSING":
        step = 1;
        break;
      case "DELIVERY_REFUSED":
        step = 1;
        break;
      case "DELIVERY_ACCEPTED":
        step = 2;
        break;
      case "DELIVERY_CANCELED":
        step = 2;
        break;
      case "SENDED":
        step = 2;
        break;
      case "CANCELED":
        step = 1;
        break;
      case "REFUSED":
        step = 0;
        break;
      case "CONCLUDED":
        step = 3;
        break;
      default:
        step = 0;
        break;
    }
    List<Widget> balls = [];
    for (var i = 0; i <= ((steps - 1) * 6); i++) {
      bool sixMultiple = i % 6 == 0;
      bool lessMultiple = (i + 1) % 6 != 0;
      if (sixMultiple) {
        // print('$i é multiplo de 6');
        (status == "CANCELED" || status == "REFUSED") && i == step * 6
            ? balls.add(RedBall(isRed: i == step * 6))
            : balls.add(Ball(isPrimary: i <= step * 6));
      } else {
        // print('$i não é multiplo de 6');
        balls.add(LittleBall(
          isPrimary: i <= step * 6,
          hasPadding: lessMultiple,
        ));
      }
    }
    return balls;
  }
}

class EvaluateOrderCard extends StatelessWidget {
  final bool rated;
  final double? rating;

  final void Function() onTap;
  EvaluateOrderCard({required this.onTap, required this.rated, this.rating});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: wXD(100, context),
          width: wXD(343, context),
          margin: EdgeInsets.symmetric(vertical: wXD(24, context)),
          padding: EdgeInsets.symmetric(
            horizontal: wXD(16, context),
            vertical: wXD(13, context),
          ),
          decoration: BoxDecoration(
            color: getColors(context).surface,
            borderRadius: defBorderRadius(context),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                offset: Offset(0, 3),
                color: getColors(context).shadow,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rated ? "Atendimento avaliado" : 'Avalie o seu atendimento',
                style: TextStyle(
                  color: getColors(context).onBackground,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Montserrat',
                ),
              ),
              RatingBar(
                onRatingUpdate: (value) {},
                initialRating: rating ?? 0,
                ignoreGestures: true,
                glowColor: getColors(context).primary.withOpacity(.4),
                unratedColor: getColors(context).primary.withOpacity(.4),
                allowHalfRating: true,
                itemSize: wXD(35, context),
                ratingWidget: RatingWidget(
                  full: Icon(Icons.star_rounded,
                      color: getColors(context).primary),
                  empty: Icon(Icons.star_outline_rounded,
                      color: getColors(context).primary),
                  half: Icon(Icons.star_half_rounded,
                      color: getColors(context).primary),
                ),
              ),
              Text(
                rated
                    ? "Esta é a média da sua avaliação"
                    : 'Escolha de 1 a 5 estrelas para classificar',
                style: TextStyle(
                  color: getColors(context).onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SendMessage extends StatelessWidget {
  final String text;
  final void Function() onTap;
  const SendMessage(this.text, this.onTap, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: wXD(56, context),
          width: wXD(343, context),
          margin: EdgeInsets.only(bottom: wXD(10, context)),
          padding:
              EdgeInsets.only(bottom: wXD(15, context), top: wXD(15, context)),
          decoration: BoxDecoration(
            borderRadius: defBorderRadius(context),
            color: getColors(context).surface,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                offset: Offset(0, 3),
                color: getColors(context).shadow,
              )
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: wXD(30, context), right: wXD(3, context)),
                child: Icon(
                  Icons.email_outlined,
                  color: getColors(context).primary,
                  size: wXD(20, context),
                ),
              ),
              Text(
                text,
                style: textFamily(
                  context,
                  fontSize: 14,
                  color: getColors(context).primary,
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: wXD(14, context)),
                child: Icon(
                  Icons.arrow_forward,
                  color: getColors(context).primary,
                  size: wXD(20, context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RedBall extends StatelessWidget {
  final bool isRed;

  RedBall({Key? key, required this.isRed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: wXD(7, context)),
      height: wXD(6, context),
      width: wXD(6, context),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isRed ? red : Color(0xffbdbdbd),
      ),
    );
  }
}

class Ball extends StatelessWidget {
  final bool isPrimary;

  const Ball({Key? key, required this.isPrimary}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: wXD(7, context)),
      height: wXD(6, context),
      width: wXD(6, context),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPrimary ? getColors(context).primary : Color(0xffbdbdbd),
      ),
    );
  }
}

class LittleBall extends StatelessWidget {
  final bool isPrimary;
  final bool hasPadding;

  const LittleBall({
    Key? key,
    required this.isPrimary,
    required this.hasPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('padding: $padding');
    return Container(
      margin: EdgeInsets.only(bottom: hasPadding ? wXD(6, context) : 0),
      height: wXD(4, context),
      width: wXD(4, context),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPrimary
            ? getColors(context).primary.withOpacity(.5)
            : getColors(context).onSurface.withOpacity(.3),
      ),
    );
  }
}

class Step extends StatelessWidget {
  final String title, subTitle, orderStatus;
  Step({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.orderStatus,
  }) : super(key: key);
  final OrdersStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    Color titleColor = getColors(context).onBackground;
    Color textColor = getColors(context).onBackground.withOpacity(.8);
    if (title == "Entregue" && orderStatus != "CONCLUDED") {
      titleColor = getColors(context).onBackground.withOpacity(.4);
      textColor = getColors(context).onSurface;
    }
    return Container(
      margin: EdgeInsets.only(bottom: wXD(28, context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
          Text(
            subTitle,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}
