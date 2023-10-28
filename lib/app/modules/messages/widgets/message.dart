import 'package:cached_network_image/cached_network_image.dart';
import 'package:diaclean_customer/app/core/models/message_model.dart';
import 'package:diaclean_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import '../../../constants/properties.dart';
import '../../../core/models/time_model.dart';

class MessageWidget extends StatelessWidget {
  final Message messageData;
  final bool isAuthor;
  final bool messageBold;

  const MessageWidget({
    Key? key,
    required this.messageData,
    required this.isAuthor,
    required this.messageBold,
  }) : super(key: key);

  @override
  Widget build(context) {
    return Container(
      width: maxWidth(context),
      // padding: EdgeInsets.only(top: wXD(18, context)),
      alignment: isAuthor ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isAuthor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          messageData.fileType != null &&
                  messageData.fileType!.startsWith("image/")
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: isAuthor
                        ? getColors(context).primary.withOpacity(1)
                        : getColors(context).primary.withOpacity(.5),
                  ),
                  margin: EdgeInsets.only(
                    top: wXD(8, context),
                    right: wXD(10, context),
                    left: wXD(10, context),
                  ),
                  // height: wXD(285, context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(wXD(3, context),
                            wXD(3, context), wXD(3, context), wXD(2, context)),
                        height: wXD(250, context),
                        constraints: BoxConstraints(
                            minWidth: wXD(150, context),
                            maxWidth: wXD(250, context)),
                        child: ClipRRect(
                          borderRadius: defBorderRadius(context),
                          child: CachedNetworkImage(
                            imageUrl: messageData.file!,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, _, a) =>
                                const Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: wXD(10, context), bottom: wXD(2, context)),
                        child: Text(
                          messageData.createdAt != null
                              ? Time(messageData.createdAt!.toDate()).hour()
                              : "",
                          textAlign:
                              isAuthor ? TextAlign.right : TextAlign.left,
                          style: textFamily(
                            context,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: getColors(context).onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              // Container(
              //     padding: EdgeInsets.all(wXD(7, context)),
              //     margin: EdgeInsets.only(
              //       top: wXD(8, context),
              //       left: isAuthor ? wXD(100, context) : wXD(10, context),
              //       right: isAuthor ? wXD(10, context) : wXD(100, context),
              //     ),
              //     decoration: BoxDecoration(
              //       borderRadius: defBorderRadius(context),
              //       color: isAuthor ? getColors(context).onBackground : getColors(context).primary,
              //     ),
              //     alignment: Alignment.center,
              //     child: Column(
              //       crossAxisAlignment: isAuthor
              //           ? CrossAxisAlignment.end
              //           : CrossAxisAlignment.start,
              //       children: [
              //         ClipRRect(
              //           borderRadius: defBorderRadius(context),
              //           child: CachedNetworkImage(
              //             imageUrl: messageData.file!,
              //             progressIndicatorBuilder: (context, _, a) =>
              //                 CircularProgressIndicator(
              //               valueColor:
              //                   AlwaysStoppedAnimation(getColors(context).primary),
              //             ),
              //           ),
              //         ),
              //         SizedBox(height: wXD(3, context)),
              //         Text(
              //           messageData.createdAt != null ?
              //           Time(messageData.createdAt!.toDate()).hour() : "",
              //           textAlign: isAuthor ? TextAlign.right : TextAlign.left,
              //           style: textFamily(context,
              //             fontSize: 11,
              //             fontWeight: FontWeight.w400,
              //             color: isAuthor
              //                 ?getColors(context).onSurface
              //                 : getColors(context).onBackground,
              //           ),
              //         ),
              //       ],
              //     ),
              //   )
              : Container(
                  margin: EdgeInsets.only(
                    left: isAuthor ? wXD(36, context) : 8,
                    right: isAuthor ? 8 : wXD(36, context),
                    top: wXD(8, context),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: defBorderRadius(context),
                    color: isAuthor
                        ? getColors(context).primary.withOpacity(1)
                        : getColors(context).primary.withOpacity(.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          wXD(15, context),
                          wXD(11, context),
                          wXD(46, context),
                          wXD(0, context),
                        ),
                        child: Text(
                          messageData.text!,
                          textAlign: TextAlign.left,
                          style: textFamily(
                            context,
                            fontSize: 14,
                            fontWeight:
                                messageBold ? FontWeight.bold : FontWeight.w400,
                            color: getColors(context).onPrimary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: wXD(10, context), bottom: wXD(2, context)),
                        child: Text(
                          messageData.createdAt != null
                              ? Time(messageData.createdAt!.toDate()).hour()
                              : "",
                          textAlign:
                              isAuthor ? TextAlign.right : TextAlign.left,
                          style: textFamily(
                            context,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: getColors(context).onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
