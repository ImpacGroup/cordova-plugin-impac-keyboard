function ImpacKeyboard() {}

ImpacKeyboard.prototype.showKeyboard = function() {
    cordova.exec(null, null, 'ImpacKeyboard', 'showKeyboard', []);
}

ImpacKeyboard.prototype.onSendMessage = function(callback) {
    cordova.exec(callback, null, 'ImpacKeyboard', 'onSendMessage', []);
}

ImpacKeyboard.prototype._getErrorCallback = function (ecb, functionName) {
    if (typeof ecb === 'function') {
        return ecb;
    } else {
        return function (result) {
            console.log("The injected error callback of '" + functionName + "' received: " + JSON.stringify(result));
          }
    }
};

ImpacKeyboard.install = function() {
    if (!window.plugins) {
        window.plugins = {};
    }
    window.plugins.impacKeyboard = new ImpacKeyboard();
    return window.plugins.impacKeyboard;
}

cordova.addConstructor(ImpacKeyboard.install);