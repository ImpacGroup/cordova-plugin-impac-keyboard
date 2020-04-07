package de.impacgroup.cordovakeyboard;

import android.app.Application;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.Color;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

public class IMPChatkeyboard extends CordovaPlugin {

    private View chatInputView;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        Context context = this.cordova.getActivity().getApplicationContext();
    }

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final FrameLayout frameLayout =  (FrameLayout) webView.getView().getParent();
        switch (action) {
            case "showKeyboard":
                if (chatInputView == null) {
                    Application app=cordova.getActivity().getApplication();
                    String package_name = app.getPackageName();
                    Resources resources = app.getResources();
                    int ic = resources.getIdentifier("chat_input_view", "layout", package_name);
                    chatInputView = LayoutInflater.from(this.cordova.getActivity()).inflate(ic, null);
                    FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT, Gravity.BOTTOM);
                    chatInputView.setLayoutParams(params);
                    this.cordova.getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            frameLayout.addView(chatInputView);
                        }
                    });
                }
                return true;
            case "onSendMessage":
                return true;
            case "onInputChanged":
                return true;
            case "setColor":
                String colorString = args.getString(0);
                if (chatInputView != null && colorString != null) {
                    Button button = chatInputView.findViewById(R.id.sendButton);
                    button.setBackgroundColor(Color.parseColor(colorString));
                    return true;
                } else {
                    return false;
                }
            case "setImage":
                return true;
            case "hideKeyboard":
                if (chatInputView != null) {
                    frameLayout.removeView(chatInputView);
                    chatInputView = null;
                }
                return true;
            default:
                callbackContext.error("\"" + action + "\" is not a recognized action.");
                break;
        }
        return false;
    }

}
