//
//  IMPKeyboardPlugin.swift
//  ChatKeyboard-Test
//
//  Created by Felix Nievelstein on 29.03.20.
//  Copyright © 2020 Impac Gmbh. All rights reserved.
//

import Foundation

fileprivate let height: CGFloat = 60.0;

@objc (ImpacKeyboard) class ImpacKeyboard: CDVPlugin, InputViewDelegate {
    
    var chatInputView: IMPInputView?
    var bottomConst: NSLayoutConstraint?
    private var onSendCallbackId: String?
    private var onInputCallbackId: String?
    var btmView: UIView?
    var defaultSize: CGRect?
    var keyboardSize: CGRect?
    
    @objc(showKeyboard:) func showKeyboard(command: CDVInvokedUrlCommand) {
        if chatInputView == nil {
            chatInputView = IMPInputView(frame: CGRect(x: 0, y: 0, width: viewController.view.frame.size.width, height: height))
            chatInputView?.delegate = self
            btmView = UIView(frame: CGRect(x: 0, y: viewController.view.frame.size.height - viewController.view.safeAreaInsets.bottom, width: viewController.view.frame.size.width, height: viewController.view.safeAreaInsets.bottom))
            btmView?.backgroundColor = UIColor(hex: "#F2F4F7")
            viewController.view.addSubview(chatInputView!)
            viewController.view.addSubview(btmView!)
            addConstraints(constraintView: chatInputView!)
            addKeyboardObserver()
            defaultSize = webView.frame;
            updateWebViewSize(show: true, open: false)
        }
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: true)
        self.commandDelegate.send(result, callbackId: command.callbackId)
    }
    
    private func updateWebViewSize(show: Bool, open: Bool) {
        if let mSize = defaultSize {
            if !show {
                webView.frame = mSize
            } else {
                if open, let mKeySize = keyboardSize {
                    webView.frame = CGRect(x: webView.frame.origin.x, y: webView.frame.origin.y, width: webView.frame.size.width, height: mSize.height - (height + mKeySize.height))
                } else {
                    webView.frame = CGRect(x: webView.frame.origin.x, y: webView.frame.origin.y, width: webView.frame.size.width, height: mSize.height - (height + viewController.view.safeAreaInsets.bottom))
                }
            }
        }
    }
    
    @objc(onSendMessage:) func onSendMessage(command: CDVInvokedUrlCommand) {
        onSendCallbackId = command.callbackId
    }
    
    @objc(onInputChanged:) func onInputChanged(command: CDVInvokedUrlCommand) {
        onInputCallbackId = command.callbackId
    }
    
    @objc(setImage:) func setImage(command: CDVInvokedUrlCommand) {
        if command.arguments.count == 1, let base64Img = command.arguments[0] as? String {
            if let mChatInputView = chatInputView, let img = imageForBase64String(base64Img) {
                mChatInputView.sendButton.setImage(img, for: .normal)
            }
        } else {
            print("ImpacInappPayment: Invalid arguments, missing image base 64 string")
        }
    }
    
    func imageForBase64String(_ strBase64: String) -> UIImage? {

        do{
            let imageData = try Data(contentsOf: URL(string: strBase64)!)
            let image = UIImage(data: imageData)
            return image!
        }
        catch{
            return nil
        }
    }
    
    @objc(setColor:) func setColor(command: CDVInvokedUrlCommand) {
        if command.arguments.count == 1, let color = command.arguments[0] as? String {
            if let mChatInputView = chatInputView, let mColor = UIColor(hex: color) {
                mChatInputView.setButtonColor(color: mColor)
            }
        } else {
            print("ImpacInappPayment: Invalid arguments, missing color string")
        }
    }
    
    @objc(hideKeyboard:) func hideKeyboard(command: CDVInvokedUrlCommand) {
        if let mChatInputView = chatInputView {
            mChatInputView.removeFromSuperview()
            chatInputView = nil
            updateWebViewSize(show: false, open: false)
        }
    }
    
    
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func addConstraints(constraintView: UIView) {
        let leftConst = NSLayoutConstraint(item: viewController.view, attribute: .leading, relatedBy: .equal, toItem: constraintView, attribute: .leading, multiplier: 1.0, constant: 0)
        let rightConst = NSLayoutConstraint(item: viewController.view, attribute: .trailing, relatedBy: .equal, toItem: constraintView, attribute: .trailing, multiplier: 1.0, constant: 0)
        bottomConst = NSLayoutConstraint(item: viewController.view.safeAreaLayoutGuide, attribute: .bottom, relatedBy: .equal, toItem: constraintView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let heightConst = NSLayoutConstraint(item: constraintView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        viewController.view.addConstraints([leftConst, rightConst, heightConst, bottomConst!])
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let mkeyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let mConst = bottomConst {
            keyboardSize = mkeyboardSize
            mConst.constant = mkeyboardSize.height - viewController.view.safeAreaInsets.bottom
            viewController.view.layoutIfNeeded()
            updateWebViewSize(show: true, open: true)
            
            let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "")
            result?.keepCallback = true
            self.commandDelegate.send(result, callbackId: onInputCallbackId)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let mConst = bottomConst {
            mConst.constant = 0
            viewController.view.layoutIfNeeded()
            updateWebViewSize(show: true, open: false)
            
            let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "")
            result?.keepCallback = true
            self.commandDelegate.send(result, callbackId: onInputCallbackId)
        }
    }
    
    func sendText(text: String) {
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: text)
        result?.keepCallback = true
        self.commandDelegate.send(result, callbackId: onSendCallbackId)
    }
}

