import 'package:webrtc_interface/webrtc_interface.dart';

/// Stub: no native track pipeline (e.g. Flutter web). Methods return inert values.
extension HippoMediaStreamTrack on MediaStreamTrack {
  Future<bool> isZoomSupported() => Future.value(false);

  Future<void> setZoom(int value) => Future.value();

  Future<int> getZoom() => Future.value(1);

  Future<int> setZoom1() => Future.value(1);

  Future<int> setZoom2() => Future.value(1);

  Future<int> setZoom3() => Future.value(1);

  Future<int> setZoom4() => Future.value(1);

  Future<int> setZoom5() => Future.value(1);

  Future<int> getMaxZoom() => Future.value(1);

  Future<bool> setLightOn() => Future.value(false);

  Future<bool> setLightOff() => Future.value(false);

  Future<bool> getLightStatus() => Future.value(false);

  Future<int> turnLightOn() => Future.value(100);

  Future<int> turnLightOn1(int a) => Future.value(100);

  Future<int> turnLightOff() => Future.value(100);

  Future<int> turnLightOff1(int a) => Future.value(100);

  Future<int> turnLightStatus() => Future.value(100);

  Future<int> turnLightStatus1(int a) => Future.value(100);
}
