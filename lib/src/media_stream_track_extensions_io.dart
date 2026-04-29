import 'package:webrtc_interface/webrtc_interface.dart';

import 'native/media_stream_track_impl.dart';

/// Native (Android/iOS) camera helpers on [MediaStreamTrack].
///
/// See also [MediaStreamTrack.hasTorch] / [MediaStreamTrack.setTorch] on the
/// base interface from `webrtc_interface`.
extension HippoMediaStreamTrack on MediaStreamTrack {
  MediaStreamTrackNative _nativeOrThrow() {
    final self = this;
    if (self is MediaStreamTrackNative) return self;
    throw UnsupportedError(
      'Hippo WebRTC camera extensions require a native track; got ${self.runtimeType}.',
    );
  }

  Future<bool> isZoomSupported() => _nativeOrThrow().isZoomSupported();

  Future<void> setZoom(int value) => _nativeOrThrow().setZoom(value);

  Future<int> getZoom() => _nativeOrThrow().getZoom();

  Future<int> setZoom1() => _nativeOrThrow().setZoom1();

  Future<int> setZoom2() => _nativeOrThrow().setZoom2();

  Future<int> setZoom3() => _nativeOrThrow().setZoom3();

  Future<int> setZoom4() => _nativeOrThrow().setZoom4();

  Future<int> setZoom5() => _nativeOrThrow().setZoom5();

  Future<int> getMaxZoom() => _nativeOrThrow().getMaxZoom();

  Future<bool> setLightOn() => _nativeOrThrow().setLightOn();

  Future<bool> setLightOff() => _nativeOrThrow().setLightOff();

  Future<bool> getLightStatus() => _nativeOrThrow().getLightStatus();

  Future<int> turnLightOn() => _nativeOrThrow().turnLightOn();

  Future<int> turnLightOn1(int a) => _nativeOrThrow().turnLightOn1(a);

  Future<int> turnLightOff() => _nativeOrThrow().turnLightOff();

  Future<int> turnLightOff1(int a) => _nativeOrThrow().turnLightOff1(a);

  Future<int> turnLightStatus() => _nativeOrThrow().turnLightStatus();

  Future<int> turnLightStatus1(int a) => _nativeOrThrow().turnLightStatus1(a);
}
