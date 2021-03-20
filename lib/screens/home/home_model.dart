import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_call_app/screens/call/call_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeNotifier extends ChangeNotifier {
  bool _validateError = false;

  bool get validateError => _validateError;

  setValue(bool value) {
    _validateError = value;
    notifyListeners();
  }

  Future<void> onJoin(BuildContext context, String chanelName) async {
    if (chanelName.isEmpty) {
      setValue(true);
    } else {
      setValue(false);
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallScreen(
                    channelName: chanelName,
                  )));
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print("Permissions status: $status");
  }
}
