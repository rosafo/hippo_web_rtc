// HippoWebRtc
// import 'hippo_web_rtc_platform_interface.dart';
//
// class HippoWebRtc {
//   Future<String?> getPlatformVersion() {
//     return HippoWebRtcPlatform.instance.getPlatformVersion();
//   }
// }
library hippo_web_rtc;

export 'package:webrtc_interface/webrtc_interface.dart'
    hide MediaDevices, MediaRecorder, Navigator;

export 'src/desktop_capturer.dart';
export 'src/helper.dart';
export 'src/media_devices.dart';
export 'src/media_recorder.dart';
export 'src/native/factory_impl.dart'
    if (dart.library.html) 'src/web/factory_impl.dart';
export 'src/native/rtc_video_renderer_impl.dart'
    if (dart.library.html) 'src/web/rtc_video_renderer_impl.dart';
export 'src/native/rtc_video_view_impl.dart'
    if (dart.library.html) 'src/web/rtc_video_view_impl.dart';
export 'src/native/utils.dart' if (dart.library.html) 'src/web/utils.dart';
export 'src/media_stream_track_extensions.dart';
