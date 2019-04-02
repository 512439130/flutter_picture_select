package com.yy.flutter_picture_select;

import android.content.Context;
import android.os.Bundle;

import com.yy.flutter_picture_select.plugin.FilePickerPlugin;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static Context mContext = null;
  private static final String METHOD_CHANNEL = "openFileChannel";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    // FilePickerPlugin.registerWith(registry.registrarFor("com.yy.flutter_picture_select.plugin.FilePickerPlugin"));

    mContext = this;
    registerCustomPlugin(this);
  }
  private static void registerCustomPlugin(PluginRegistry registrar) {

    FilePickerPlugin.registerWith(registrar.registrarFor("com.yy.flutter_picture_select.plugin.FilePickerPlugin"));
  }



}
