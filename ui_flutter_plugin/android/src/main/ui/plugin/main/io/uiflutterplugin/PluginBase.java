package android.src.main.ui.plugin.main.io.uiflutterplugin;

import android.content.Context;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Created by YangYxd on 2018-04-24.
 */

public abstract class PluginBase {
    public void onMethodCall(Context context, MethodCall call, MethodChannel.Result result) {
        result.notImplemented();
    }
}
