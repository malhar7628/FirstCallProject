import 'package:elvtr/screen/tooglebuttoon.screen.dart';
import 'package:elvtr/widget/audition_id_dialog_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/transaction.model.dart';
import '../service/network.service.dart';
import '../widget/VideoLoadingWidgetText.dart';
import '../widget/loading.widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widget/otp_dialog.widget.dart';

final NetworkService _networkService = Get.find();

// ShowVideoModel sm = ShowVideoModel();

showSnackbar(String message) {
  if (Get.isSnackbarOpen) {
    Get.closeCurrentSnackbar();
  }
  Get.showSnackbar(
    GetSnackBar(
      message: message,
    ),
  );
}

// showAuditionIDDialog() {
//   Get.dialog( AuditionIDDialogWidget(video: video.category.id));
// }

showLoadingDialog() {
  Get.dialog(const LoadingWidget());
}
showVideoLoadingDialog() {
  Get.dialog(const VideoLoadingWidget());
}
removeDialog() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}

Future<bool?> showConfirmationDialogAfterSucessRecord(
    {required String title, required String content}) async {
  return await Get.dialog<bool?>(
    AlertDialog(
      title: Text(title),titleTextStyle:  GoogleFonts.lato(
        fontSize: 15,
        color: Colors.black.withOpacity(.9)
    ),
      content: Text(content),
      actions: [
        Column(
          children: [
            /*IconButton(
                onPressed: () {
                  *//*showLoadingDialog();
            //  editController.getSelectedFile();
              removeDialog();*/
            /*
                }, icon: Icon(null)
            ),*/
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0.0),
                  elevation: 5,
                ),
                onPressed: () {
                  Get.back(result: true);
                },
                child: Ink(
                  decoration: BoxDecoration(

                    gradient: LinearGradient(colors: [  const Color(0x001e96ca).withOpacity(0.9),
                      const Color(0x00007238).withOpacity(0.9),]),
                    //   borderRadius: BorderRadius.circular(90),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    constraints: const BoxConstraints(minWidth: 88.0),
                    child: const Text('Ok', textAlign: TextAlign.center),
                  ),
                ),
              ),
            )
          ],
        ),
        /*  SizedBox(width: 20),
        Column(
          children: [
            IconButton(
                onPressed: () {
                  // editController.getSelectedFile();
                }, icon: Icon(null)
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0.0),
                elevation: 5,
              ),
              onPressed: () {
                Get.back(result: true);
              },
              child: Ink(
                decoration: BoxDecoration(

                  gradient: LinearGradient(colors: [  const Color(0x001e96ca).withOpacity(0.9),
                    const Color(0x00007238).withOpacity(0.9),]),
                  //   borderRadius: BorderRadius.circular(90),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(minWidth: 88.0),
                  child: const Text('Without CV', textAlign: TextAlign.center),
                ),
              ),
            )
          ],
        )*/
      ],
    ),
  );
}


showAlertDialog({required String title, required String content}) async {
  return await Get.dialog(
    WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("OK",style: TextStyle(
              color: Colors.black
            ),),
          )
        ],
      ),
    ),
  );
}

showToast(String message) async {
  await Fluttertoast.cancel();
  await Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_LONG);
}

Future<bool?> showConfirmationDialog(
    {required String title, required String content}) async {
  return await Get.dialog<bool?>(
    AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: false);
          },
          child: const Text("No",style: TextStyle(color: Colors.black),),
        ),
        TextButton(
          onPressed: () {
            Get.back(result: true);
          },
          child: const Text("Continue",style: TextStyle(color: Colors.black),),
        )
      ],
    ),
  );
}
Future<bool?> showConfirmationDialogAterRecord(
    {required String title, required String content}) async {
  return await Get.dialog<bool?>(
    AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: true);
          },
          child: const Text("Continue",style: TextStyle(color: Colors.black),),
        )
      ],
    ),
  );
}
showChargingPointDetail(/*ChargingPointModel point*/) {
  /*return Get.toNamed(
      BookingScreen.name,
      arguments: {"point": point,"nw":null});*/
}
Future<bool?> showOtpDialog(Function(String value) onOtpVerification) async {
  return await Get.dialog<bool?>(
    WillPopScope(
      onWillPop: () async => false,
      child: OtpDialog(onOtpVerification: onOtpVerification),
    ),
    barrierDismissible: false,
  );
}
Future<bool?> showOtpDialogSignUp(Function(String value) onOtpVerification) async {
  return await Get.dialog<bool?>(
    WillPopScope(
      onWillPop: () async => false,
      child: OtpDialog(onOtpVerification: onOtpVerification),
    ),
    barrierDismissible: false,
  );
}
showNotification(
    {required int id, required String title, required String body}) {
  FlutterLocalNotificationsPlugin().show(
    id,
    title,
    body,
    const NotificationDetails(
        android: AndroidNotificationDetails(
            "charging_status", "Charging Status",
            channelDescription: "Receive charging status notifications"),
        iOS: DarwinNotificationDetails()),
  );
}
