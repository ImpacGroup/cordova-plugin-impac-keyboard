# README #

### Cordova Plugin for iOS and Android to present a native input field for chat applications. ###

## Supported platforms

- Android 5+
- iOS 11+


## Installation

```js
cordova plugin add cordova-plugin-impac-keyboard
```

## Show / hide input field

To add the input field to the current screen perform *showKeyboard*.

```js
window.plugins.impacKeyboard.showKeyboard(() => {
  // Keyboard is presented
});
```

To remove the input field again perform *hideKeyboard*

```js
window.plugins.impacKeyboard.hideKeyboard(() => {
  // Keyboard removed
});
```
