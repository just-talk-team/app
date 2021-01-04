import 'dart:io';

import 'package:f_logs/f_logs.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:path_provider/path_provider.dart';

class EmailService {
  EmailService();

  Future<void> sendLogs() async {
    await FLog.exportLogs();
    Directory dir = await getExternalStorageDirectory();

    final MailOptions mailOptions = MailOptions(
      body: "App Logs",
      subject: "Logs",
      recipients: <String>['josered30@hotmail.com'],
      attachments: ["${dir.path}/FLogs/flog.txt"],
    );

    String platformResponse;

    try {
      final MailerResponse response = await FlutterMailer.send(mailOptions);
      switch (response) {
        case MailerResponse.saved:
          platformResponse = 'mail was saved to draft';
          break;
        case MailerResponse.sent:
          platformResponse = 'mail was sent';
          break;
        case MailerResponse.cancelled:
          platformResponse = 'mail was cancelled';
          break;
        case MailerResponse.android:
          platformResponse = 'intent was success';
          break;
        default:
          platformResponse = 'unknown';
          break;
      }
    } on PlatformException catch (error) {
      platformResponse = error.toString();
    } catch (error) {
      platformResponse = error.toString();
    }
    print(platformResponse);
  }
}
