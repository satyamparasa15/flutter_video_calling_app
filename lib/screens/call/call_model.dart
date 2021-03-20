import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_video_call_app/utils/utils.dart';

class CallNotifier extends ChangeNotifier {
  var _users = <int>[];
  var _infoStrings = <String>[];
  bool _isMuted = false;
  RtcEngine _engine;

  RtcEngine get engine => _engine;

  set setEngine(RtcEngine engine) {
    _engine = engine;
    notifyListeners();
  }

  bool get isMuted => _isMuted;

  set isMuted(value) {
    _isMuted = !value;
    notifyListeners();
  }

  get users => _users;

  addUser(value) {
    _users.add(value);
    notifyListeners();
  }

  get infoStrings => _infoStrings;

  infoString(String value) {
    _infoStrings.add(value);
    notifyListeners();
  }

  removeUser(value) {
    _users.remove(value);
    notifyListeners();
  }

  clearUsers() {
    _users.clear();
    notifyListeners();
  }

  Future<void> init(String channelName) async {
    if (APP_ID.isEmpty) {
      infoString('APP_ID missing, please provide your APP_ID in settings.dart');
      infoString('Agora Engine is not starting');
      return;
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableLocalVideo(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(Token, channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    setEngine = _engine;
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
        error: (code) {
          infoString('onError: $code');
        },
        joinChannelSuccess: (channel, uid, elapsed) {
          infoString('onJoinChannel: $channel, uid: $uid');
        },
        leaveChannel: (stats) {
          infoString('onLeaveChannel');
          _users.clear();
        },
        userJoined: (uid, elapsed) {
          infoString('userJoined: $uid');
          addUser(uid);
        },
        userOffline: (uid, elapsed) {
          infoString('userOffline: $uid');
          removeUser(uid);
        },
        firstRemoteVideoFrame: (uid, width, height, elapsed) {}));
  }

  @override
  void dispose() {
    clearUsers();
    _engine.destroy();
    _engine.leaveChannel();
    super.dispose();
  }
}
