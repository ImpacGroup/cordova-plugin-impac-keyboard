package de.impacgroup.cordovakeyboard;

import android.app.Application;
import android.content.res.ColorStateList;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.util.Base64;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.LinearLayout;

import androidx.annotation.Nullable;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

public class IMPChatkeyboard extends CordovaPlugin {

    private View chatInputView;
    private CallbackContext sendButtonCallbackContext;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
    }

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        final FrameLayout frameLayout =  (FrameLayout) webView.getView().getParent();
        switch (action) {
            case "showKeyboard":
                if (chatInputView == null) {
                    Application app = cordova.getActivity().getApplication();
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
                            callbackContext.success();
                            updateWebViewSize(true);
                        }
                    });
                }
                return true;
            case "onSendMessage":{
                this.sendButtonCallbackContext = callbackContext;
                final ImageButton button = getSendButton();
                final EditText editText = getTextView();
                if (button != null && editText != null) {
                    button.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            String text = editText.getText().toString();
                            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, text);
                            pluginResult.setKeepCallback(true);
                            sendButtonCallbackContext.sendPluginResult(pluginResult);
                            editText.setText("");
                        }
                    });
                }
                return true;
            }
            case "onInputChanged":
                return true;
            case "setColor": {
                final String colorString = args.getString(0);
                final ImageButton button = getSendButton();
                if (button != null && colorString != null) {
                    this.cordova.getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            button.setBackgroundTintList(ColorStateList.valueOf(Color.parseColor(colorString)));
                        }
                    });
                    return true;
                } else {
                    return false;
                }
            }
            case "setImage": {
                String base64String = args.getString(0).replace("data:image/png;base64,", "");
                final ImageButton button = getSendButton();
                if (button != null) {
                    byte[] decodedString = Base64.decode(base64String, Base64.NO_WRAP);
                    final Bitmap decodedByte = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
                    this.cordova.getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            button.setImageBitmap(decodedByte);
                        }
                    });
                    return true;
                }
                return false;
            }
            case "hideKeyboard":
                if (chatInputView != null) {
                    this.cordova.getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            frameLayout.removeView(chatInputView);
                            chatInputView = null;
                            updateWebViewSize(false);
                        }
                    });
                }
                return true;
            default:
                callbackContext.error("\"" + action + "\" is not a recognized action.");
                break;
        }
        return false;
    }

    private void updateWebViewSize(boolean open) {
        Resources r = cordova.getActivity().getResources();
        if (open) {
            float px = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 66, r.getDisplayMetrics());
            int height = webView.getView().getHeight() - (int) px;
            webView.getView().setLayoutParams(new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, height));
        } else {
            webView.getView().setLayoutParams(new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
        }
    }

    private @Nullable ImageButton getSendButton() {
        return (ImageButton) getViewByName("sendButton");
    }

    private @Nullable EditText getTextView() {
        return (EditText) getViewByName("inputEditText");
    }

    private @Nullable View getViewByName(String name) {
        if (chatInputView != null) {
            Application app = cordova.getActivity().getApplication();
            Resources resources = app.getResources();
            int ic = resources.getIdentifier(name, "id", app.getPackageName());
            return chatInputView.findViewById(ic);
        }
        return null;
    }
}
