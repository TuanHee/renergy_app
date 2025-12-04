import 'package:flutter/material.dart';

class Snackbar {
  static void showInfo(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey[50],
        shape: Border(bottom: BorderSide(color: Colors.grey[700]!, width: 4)),
        content: Flex(
          direction: Axis.horizontal,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: Icon(Icons.info, color: Colors.white),
            ),
            Expanded(child: Text(message, style: TextStyle(color: Colors.black) ,overflow: TextOverflow.ellipsis,)),
          ],
        ),
      ),
    );
  }

  static void showError(String message, BuildContext context) {
    print('message: $message');
    print('StackTrace: ${StackTrace.current}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red[50],
        shape: Border(bottom: BorderSide(color: Colors.red[700]!, width: 4)),
        content: Flex(
          direction: Axis.horizontal,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.red[700],
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: Icon(Icons.close, color: Colors.white),
            ),
            Expanded(child: Text(message, style: TextStyle(color: Colors.black))),
          ],
        ),
      ),
    );
  }

  static void showSuccess(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green[50],
        shape: Border(bottom: BorderSide(color: Colors.green[700]!, width: 4)),
        content: Flex(
          direction: Axis.horizontal,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: Icon(Icons.check, color: Colors.white),
            ),
            Expanded(child: Text(message, style: TextStyle(color: Colors.black) ,overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}
