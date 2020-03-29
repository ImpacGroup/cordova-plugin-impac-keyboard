

// Empty constructor
function ImpacKeyboard() {}

ImpacKeyboard.prototype.showKeyboard = function(ids) {
    cordova.exec(null, null, 'ImpacKeyboard', 'showKeyboard', []);
}

ImpacKeyboard.prototype.onSendMessage = function(ids) {
    cordova.exec(null, null, 'ImpacKeyboard', 'onSendMessage', []);
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
    window.plugins.impacKeyboard = new impacKeyboard();
    return window.plugins.impacKeyboard;
}
cordova.addConstructor(ImpacKeyboard.install);
