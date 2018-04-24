package ui.plugin.main.io.uiflutterplugin;

import android.content.Context;

import java.util.HashMap;
import java.util.Map;
import java.lang.*;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * UiFlutterPlugin
 */
public class UiFlutterPlugin implements MethodCallHandler {
  public Context context = null;
  public static Map<String, Class> Plugins = new HashMap<String, Class>();

  /**
   * 注册插件
   * @param name
   * @param plugin
   */
  public static void RegPlugin(String name, Class plugin) {
    if (plugin == null)
      return;
    if (Plugins.containsKey(name))
      Plugins.remove(name);
    Plugins.put(name, plugin);
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "ui_flutter_plugin");
    UiFlutterPlugin o = new UiFlutterPlugin();
    o.context = registrar.context();
    channel.setMethodCallHandler(o);

    // 注册插件
    RegPlugin("showToast", UI_Toast.class);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (Plugins.containsKey(call.method)) {
      Class cls = Plugins.get(call.method);
      if (cls != null) {
        try {
          PluginBase plugin = (PluginBase) cls.newInstance();
          plugin.onMethodCall(context, call, result);
        } catch (Exception e) {
          e.printStackTrace();
          result.error("error", e.getMessage(), e);
        }
      } else {
        result.notImplemented();
      }
    } else {
      result.notImplemented();
    }
  }
}
