package android.src.main.ui.plugin.main.io.uiflutterplugin;

import android.content.Context;
import android.view.Gravity;
import android.widget.Toast;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodCall;

/**
 * UiFlutterPlugin
 */
public class UI_Toast extends PluginBase {

  @Override
  public void onMethodCall(Context context, MethodCall call, Result result) {
    String msg = call.argument("msg");
    String length = call.argument( "length");
    String gravity = call.argument("gravity");

    Toast toast;
    if ("long".equals(length))
      toast = Toast.makeText(context, msg, Toast.LENGTH_LONG);
    else
      toast = Toast.makeText(context, msg, Toast.LENGTH_SHORT);

    if ("top".equals(gravity)) {
      toast.setGravity(Gravity.TOP, 0, 100);
    } else if ("center".equals(gravity)) {
      toast.setGravity(Gravity.CENTER, 0, 0);
    } else {
      toast.setGravity(Gravity.BOTTOM, 0, 100);
    }

    toast.show();

    result.success("Success");
  }

}
