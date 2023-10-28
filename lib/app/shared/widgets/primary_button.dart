import 'package:diaclean_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';

import '../color_theme.dart';

class PrimaryButton extends StatelessWidget {
  final double? width;
  final double? height;
  final double? fontSize;
  final Widget? child;
  final bool isWhite;
  final void Function() onTap;
  final String title;
  final Color? color;

  const PrimaryButton({
    Key? key,
    this.width,
    required this.onTap,
    this.title = '',
    this.height,
    this.child,
    this.isWhite = false,
    this.fontSize,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          color: isWhite
              ? getColors(context).surface
              : color ?? getColors(context).primary,
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(0, 3),
              color: getColors(context).shadow,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            onTap: onTap,
            child: Container(
              width: width ?? wXD(274, context),
              height: height ?? wXD(59, context),
              alignment: Alignment.center,
              child: child ??
                  Text(
                    title,
                    style: textFamily(context,
                        color: isWhite
                            ? getColors(context).primary
                            : getColors(context).onPrimary,
                        fontSize: fontSize ?? 18,
                        fontWeight: FontWeight.w600),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
