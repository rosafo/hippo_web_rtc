import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:webrtc_interface/webrtc_interface.dart';

import '../helper.dart';
import 'utils.dart';

class MediaStreamTrackNative extends MediaStreamTrack {
  MediaStreamTrackNative(this._trackId, this._label, this._kind, this._enabled);

  factory MediaStreamTrackNative.fromMap(Map<dynamic, dynamic> map) {
    return MediaStreamTrackNative(
        map['id'], map['label'], map['kind'], map['enabled']);
  }
  final String _trackId;
  final String _label;
  final String _kind;
  bool _enabled;

  bool _muted = false;

  @override
  set enabled(bool enabled) {
    WebRTC.invokeMethod('mediaStreamTrackSetEnable',
        <String, dynamic>{'trackId': _trackId, 'enabled': enabled});
    _enabled = enabled;

    if (kind == 'audio') {
      _muted = !enabled;
      muted ? onMute?.call() : onUnMute?.call();
    }
  }

  @override
  bool get enabled => _enabled;

  @override
  String get label => _label;

  @override
  String get kind => _kind;

  @override
  String get id => _trackId;

  @override
  bool get muted => _muted;

  @override
  Future<bool> hasTorch() => WebRTC.invokeMethod(
        'mediaStreamTrackHasTorch',
        <String, dynamic>{'trackId': _trackId},
      ).then((value) => value ?? false);

  Future<bool> isZoomSupported() => WebRTC.invokeMethod(
        'isZoomSupported',
        <String, dynamic>{'trackId': _trackId},
      ).then((value) => value ?? false);

  Future<void> setZoom(int value) => WebRTC.invokeMethod(
        'setZoom',
        <String, dynamic>{'trackId': _trackId, 'zoom': value},
      );

  Future<int> getZoom() => WebRTC.invokeMethod(
        'getZoom',
        <String, dynamic>{'trackId': _trackId},
      ).then((value) => value ?? 1);

  Future<int> setZoom1() {
    print('setZoom1 called');
    return WebRTC.invokeMethod(
      'setZoom1',
      <String, dynamic>{'trackId': _trackId},
    ).then((value) => value ?? 1);
  }

  Future<int> setZoom2() {
    print('setZoom2 called');
    return WebRTC.invokeMethod(
      'setZoom2',
      <String, dynamic>{'trackId': _trackId},
    ).then((value) => value ?? 1);
  }

  Future<int> setZoom3() {
    print('setZoom3 called');
    return WebRTC.invokeMethod(
      'setZoom3',
      <String, dynamic>{'trackId': _trackId},
    ).then((value) => value ?? 1);
  }

  Future<int> setZoom4() {
    print('setZoom4 called');
    return WebRTC.invokeMethod(
      'setZoom4',
      <String, dynamic>{'trackId': _trackId},
    ).then((value) => value ?? 1);
  }

  Future<int> setZoom5() {
    print('setZoom5 called');
    return WebRTC.invokeMethod(
      'setZoom5',
      <String, dynamic>{'trackId': _trackId},
    ).then((value) => value ?? 1);
  }

  Future<int> getMaxZoom() => WebRTC.invokeMethod(
        'getMaxZoom',
        <String, dynamic>{'trackId': _trackId},
      ).then((value) => value ?? 1);

  @override
  Future<void> setTorch(bool torch) => WebRTC.invokeMethod(
        'mediaStreamTrackSetTorch',
        <String, dynamic>{'trackId': _trackId, 'torch': torch},
      );

  Future<bool> setLightOn() => WebRTC.invokeMethod(
        'setLightOn',
        <String, dynamic>{'trackId': _trackId},
      ).then((value) => value ?? false);

  Future<bool> setLightOff() => WebRTC.invokeMethod(
        'setLightOff',
        <String, dynamic>{'trackId': _trackId},
      ).then((value) => value ?? false);

  Future<bool> getLightStatus() => WebRTC.invokeMethod(
        'getLightStatus',
        <String, dynamic>{'trackId': _trackId},
      ).then((value) => value ?? false);

  //=================================================================

  Future<int> turnLightOn() => WebRTC.invokeMethod(
        'turnLightOn',
        <String, dynamic>{'trackId': _trackId},
      ).then((value) => value ?? 100);

  Future<int> turnLightOn1(int a) => WebRTC.invokeMethod(
        'turnLightOn',
        <String, dynamic>{'trackId': _trackId, 'a': a},
      ).then((value) => value ?? 100);

  Future<int> turnLightOff() => WebRTC.invokeMethod(
        'turnLightOn',
        <String, dynamic>{'trackId': _trackId},
      ).then((value) => value ?? 100);

  Future<int> turnLightOff1(int a) => WebRTC.invokeMethod(
        'turnLightOn',
        <String, dynamic>{'trackId': _trackId, 'a': a},
      ).then((value) => value ?? 100);

  Future<int> turnLightStatus() => WebRTC.invokeMethod(
        'turnLightOn',
        <String, dynamic>{'trackId': _trackId},
      ).then((value) => value ?? 100);

  Future<int> turnLightStatus1(int a) => WebRTC.invokeMethod(
        'turnLightOn',
        <String, dynamic>{'trackId': _trackId, 'a': a},
      ).then((value) => value ?? 100);

  @override
  Future<bool> switchCamera() => Helper.switchCamera(this);

  @Deprecated('Use Helper.setSpeakerphoneOn instead')
  @override
  void enableSpeakerphone(bool enable) async {
    return Helper.setSpeakerphoneOn(enable);
  }

  @override
  Future<ByteBuffer> captureFrame() async {
    var filePath = await getTemporaryDirectory();
    await WebRTC.invokeMethod(
      'captureFrame',
      <String, dynamic>{
        'trackId': _trackId,
        'path': '${filePath.path}/captureFrame.png'
      },
    );
    return File('${filePath.path}/captureFrame.png')
        .readAsBytes()
        .then((value) => value.buffer);
  }

  @override
  Future<void> applyConstraints([Map<String, dynamic>? constraints]) {
    if (constraints == null) return Future.value();

    var current = getConstraints();
    if (constraints.containsKey('volume') &&
        current['volume'] != constraints['volume']) {
      Helper.setVolume(constraints['volume'], this);
    }

    return Future.value();
  }

  @override
  Future<void> dispose() async {
    return stop();
  }

  @override
  Future<void> stop() async {
    await WebRTC.invokeMethod(
      'trackDispose',
      <String, dynamic>{'trackId': _trackId},
    );
  }
}
