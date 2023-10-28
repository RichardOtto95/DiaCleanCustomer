import 'package:flutter/material.dart';

import '../shared/utilities.dart';

BorderRadius defBorderRadius(context) =>
    BorderRadius.all(Radius.circular(wXD(19, context)));

BoxShadow defBoxShadow(context) => BoxShadow(
      blurRadius: 3,
      offset: Offset(0, 3),
      color: getColors(context).shadow,
    );
