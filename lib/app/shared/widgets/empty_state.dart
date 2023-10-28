import 'package:diaclean_customer/app/shared/color_theme.dart';
import 'package:flutter/material.dart';

import '../utilities.dart';

class EmptyState extends StatelessWidget {
  final String text;
  final double? top;
  final double? height;
  final IconData icon;
  const EmptyState({
    Key? key,
    required this.text,
    this.height,
    this.top,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ??
          maxHeight(context) -
              (viewPaddingTop(context) + wXD(60, context) + wXD(30, context)),
      width: maxWidth(context),
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment:
              top != null ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            SizedBox(height: wXD(top ?? 0, context)),
            Icon(
              icon,
              size: wXD(150, context),
              color: veryDarkPurple,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: wXD(12, context)),
              child: Text(
                text,
                style: textFamily(context,
                    color: veryDarkPurple, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
