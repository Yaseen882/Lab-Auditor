import 'package:flutter/cupertino.dart';
import 'package:overlay_support/overlay_support.dart';

class Utils {
  static OverlaySupportEntry showTopSnackBar(
      BuildContext context, String message, Color color,Widget icon) {
    return showSimpleNotification(Text('Internet Connectivity Update'),
        leading: icon,
        elevation: 0.0,
        position: NotificationPosition.top,
        subtitle: Text(message), background: color);
  }
}
