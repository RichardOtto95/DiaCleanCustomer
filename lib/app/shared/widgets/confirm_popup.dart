import 'dart:ui';
import 'package:diaclean_customer/app/constants/properties.dart';
import 'package:diaclean_customer/app/shared/color_theme.dart';
import 'package:diaclean_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class ConfirmPopup extends StatelessWidget {
  final String text;
  final Future Function() onConfirm;
  final void Function() onCancel;
  final double? height;
  const ConfirmPopup({
    Key? key,
    required this.text,
    required this.onConfirm,
    required this.onCancel,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool loadCircular = false;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: onCancel,
              child: Container(
                height: maxHeight(context),
                width: maxWidth(context),
                color: getColors(context).shadow,
                alignment: Alignment.center,
              ),
            ),
            Container(
              height: height ?? wXD(145, context),
              width: wXD(327, context),
              padding: EdgeInsets.all(wXD(24, context)),
              decoration: BoxDecoration(
                borderRadius: defBorderRadius(context),
                color: getColors(context).surface,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    color: getColors(context).shadow,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: textFamily(
                      context,
                      color: getColors(context).onBackground.withOpacity(.65),
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: loadCircular
                            ? [
                                Align(
                                  child: CircularProgressIndicator(
                                    color: getColors(context).primary,
                                  ),
                                )
                              ]
                            : [
                                PopUpButton(
                                  text: 'Não',
                                  onTap: onCancel,
                                  invert: true,
                                ),
                                SizedBox(width: wXD(14, context)),
                                PopUpButton(
                                  text: 'Sim',
                                  onTap: () async {
                                    setState(() {
                                      loadCircular = true;
                                    });
                                    await onConfirm();
                                    setState(() {
                                      loadCircular = false;
                                    });
                                  },
                                ),
                              ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopUpButton extends StatelessWidget {
  final bool invert;
  final String text;
  final void Function() onTap;
  const PopUpButton(
      {Key? key, required this.text, required this.onTap, this.invert = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: wXD(41, context),
        width: wXD(78, context),
        decoration: BoxDecoration(
          borderRadius: defBorderRadius(context),
          boxShadow: [
            BoxShadow(
                blurRadius: 8,
                offset: Offset(0, 3),
                color: getColors(context).shadow)
          ],
          color: invert
              ? getColors(context).onPrimary
              : getColors(context).primary,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: textFamily(
            context,
            color: invert
                ? getColors(context).primary
                : getColors(context).onPrimary,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
