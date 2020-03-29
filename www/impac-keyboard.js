

// Empty constructor
function impacKeyboard() {}

impacKeyboard.prototype.showKeyboard = function(ids) {
    cordova.exec(null, null, 'ImpacInappPayment', 'showKeyboard', []);
}

impacKeyboard.prototype.onSendMessage = function(ids) {
    cordova.exec(null, null, 'ImpacInappPayment', 'onSendMessage', []);
}

impacKeyboard.prototype._getErrorCallback = function (ecb, functionName) {
    if (typeof ecb === 'function') {
        return ecb;
    } else {
        return function (result) {
            console.log("The injected error callback of '" + functionName + "' received: " + JSON.stringify(result));
          }
    }
};

impacKeyboard.install = function() {
    if (!window.plugins) {
        window.plugins = {};
    }
    window.plugins.impacKeyboard = new impacKeyboard();
    return window.plugins.impacKeyboard;
}
cordova.addConstructor(impacKeyboard.install);
