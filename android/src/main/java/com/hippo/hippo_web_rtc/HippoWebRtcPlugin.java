//package com.hippo.hippo_web_rtc;
//
//import androidx.annotation.NonNull;
//
//import io.flutter.embedding.engine.plugins.FlutterPlugin;
//import io.flutter.plugin.common.MethodCall;
//import io.flutter.plugin.common.MethodChannel;
//import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
//import io.flutter.plugin.common.MethodChannel.Result;
//
///** HippoWebRtcPlugin */
//public class HippoWebRtcPlugin implements FlutterPlugin, MethodCallHandler {
//  /// The MethodChannel that will the communication between Flutter and native Android
//  ///
//  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
//  /// when the Flutter Engine is detached from the Activity
//  private MethodChannel channel;
//
//  @Override
//  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
//    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "hippo_web_rtc");
//    channel.setMethodCallHandler(this);
//  }
//
//  @Override
//  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
//    if (call.method.equals("getPlatformVersion")) {
//      result.success("Android " + android.os.Build.VERSION.RELEASE);
//    } else {
//      result.notImplemented();
//    }
//  }
//
//  @Override
//  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
//    channel.setMethodCallHandler(null);
//  }
//}
package com.hippo.hippo_web_rtc;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;


import com.hippo.hippo_web_rtc.audio.AudioSwitchManager;
import com.hippo.hippo_web_rtc.utils.AnyThreadSink;
import com.hippo.hippo_web_rtc.utils.ConstraintsMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.TextureRegistry;

/**
 * HippoWebRtcPlugin
 */
public class HippoWebRtcPlugin implements FlutterPlugin, ActivityAware, EventChannel.StreamHandler {

  static public final String TAG = "FlutterWebRTCPlugin";
  private static Application application;

  private AudioSwitchManager audioSwitchManager;
  private MethodChannel methodChannel;
  private MethodCallHandlerImpl methodCallHandler;
  private LifeCycleObserver observer;
  private Lifecycle lifecycle;
  private EventChannel eventChannel;
  public EventChannel.EventSink eventSink;

  public HippoWebRtcPlugin() {
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    startListening(binding.getApplicationContext(), binding.getBinaryMessenger(),
            binding.getTextureRegistry());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    stopListening();
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    methodCallHandler.setActivity(binding.getActivity());
    this.observer = new LifeCycleObserver();
    this.lifecycle = ((HiddenLifecycleReference) binding.getLifecycle()).getLifecycle();
    this.lifecycle.addObserver(this.observer);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    methodCallHandler.setActivity(null);
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    methodCallHandler.setActivity(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivity() {
    methodCallHandler.setActivity(null);
    if (this.observer != null) {
      this.lifecycle.removeObserver(this.observer);
      if (this.application!=null) {
        this.application.unregisterActivityLifecycleCallbacks(this.observer);
      }
    }
    this.lifecycle = null;
  }

  private void startListening(final Context context, BinaryMessenger messenger,
                              TextureRegistry textureRegistry) {
    audioSwitchManager = new AudioSwitchManager(context);
    methodCallHandler = new MethodCallHandlerImpl(context, messenger, textureRegistry,
            audioSwitchManager);
    methodChannel = new MethodChannel(messenger, "FlutterWebRTC.Method");
    methodChannel.setMethodCallHandler(methodCallHandler);
    eventChannel = new EventChannel( messenger,"FlutterWebRTC.Event");
    eventChannel.setStreamHandler(this);
    audioSwitchManager.audioDeviceChangeListener = (devices, currentDevice) -> {
      Log.w(TAG, "audioFocusChangeListener " + devices+ " " + currentDevice);
      ConstraintsMap params = new ConstraintsMap();
      params.putString("event", "onDeviceChange");
      sendEvent(params.toMap());
      return null;
    };
  }

  private void stopListening() {
    methodCallHandler.dispose();
    methodCallHandler = null;
    methodChannel.setMethodCallHandler(null);
    eventChannel.setStreamHandler(null);
    if (audioSwitchManager != null) {
      Log.d(TAG, "Stopping the audio manager...");
      audioSwitchManager = null;
    }
  }

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
    eventSink = new AnyThreadSink(events);
  }
  @Override
  public void onCancel(Object arguments) {
    eventSink = null;
  }

  public void sendEvent(Object event) {
    if(eventSink != null) {
      eventSink.success(event);
    }
  }

  private class LifeCycleObserver implements Application.ActivityLifecycleCallbacks, DefaultLifecycleObserver {

    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {

    }

    @Override
    public void onActivityStarted(Activity activity) {

    }

    @Override
    public void onActivityResumed(Activity activity) {
      if (null != methodCallHandler) {
        methodCallHandler.reStartCamera();
      }
    }

    @Override
    public void onResume(LifecycleOwner owner) {
      if (null != methodCallHandler) {
        methodCallHandler.reStartCamera();
      }
    }

    @Override
    public void onActivityPaused(Activity activity) {

    }

    @Override
    public void onActivityStopped(Activity activity) {

    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {

    }

    @Override
    public void onActivityDestroyed(Activity activity) {

    }
  }
}
