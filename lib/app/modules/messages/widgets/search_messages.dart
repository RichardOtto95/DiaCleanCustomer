import 'package:diaclean_customer/app/constants/properties.dart';
import 'package:diaclean_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class SearchMessages extends StatefulWidget {
  final void Function(String) onChanged;

  SearchMessages({Key? key, required this.onChanged}) : super(key: key);
  @override
  _SearchMessagesState createState() => _SearchMessagesState();
}

class _SearchMessagesState extends State<SearchMessages> {
  FocusNode searchFocus = FocusNode();
  // bool searching = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context) - wXD(16, context),
      height: wXD(41, context),
      decoration: BoxDecoration(
        color: getColors(context).surface,
        borderRadius: defBorderRadius(context),
        border: Border.all(color: getColors(context).onSurface.withOpacity(.2)),
        boxShadow: [defBoxShadow(context)],
        // boxShadow: [
        //   BoxShadow(
        //     blurRadius: 3,
        //     offset: Offset(0, 3),
        //   ),
        // ],
      ),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: wXD(65, context),
              ),
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOutQuart,
                width: wXD(200, context),
                alignment: Alignment.center,
                child: TextField(
                  onChanged: widget.onChanged,
                  focusNode: searchFocus,
                  textAlign: TextAlign.center,
                  style: textFamily(
                    context,
                    fontSize: 14,
                    color: getColors(context).onSurface.withOpacity(.7),
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Buscar mensagens',
                    hintStyle: textFamily(
                      context,
                      fontSize: 14,
                      color: getColors(context).onSurface.withOpacity(.4),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: wXD(65, context),
                child: Padding(
                  padding: EdgeInsets.only(left: wXD(35, context)),
                  child: Icon(
                    Icons.search,
                    size: wXD(26, context),
                    color: getColors(context).onSurface.withOpacity(.4),
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
