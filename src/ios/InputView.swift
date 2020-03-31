//
//  InputView.swift
//  ChatKeyboard-Test
//
//  Created by Felix Nievelstein on 28.03.20.
//  Copyright © 2020 Impac Gmbh. All rights reserved.
//

import UIKit

protocol InputViewDelegate : class {
    func sendText(text: String)
}

class IMPInputView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    weak var delegate: InputViewDelegate?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("InputView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        self.translatesAutoresizingMaskIntoConstraints = false
        configureConstraintsForView(constraintView: view)
        
        inputContainerView.layer.cornerRadius = 4
        setButtonShadow()
    }
    
    private func setButtonShadow() {
        sendButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        sendButton.layer.shadowRadius = 3
        sendButton.layer.shadowOpacity = 0.3
        sendButton.layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        sendButton.layer.cornerRadius = sendButton.frame.height / 2
    }
    
    /**
     Set Autolayout for WKWebView
     */
    private func configureConstraintsForView(constraintView: UIView)
    {
        let leftConst = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: constraintView, attribute: .leading, multiplier: 1.0, constant: 0)
        let rightConst = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: constraintView, attribute: .trailing, multiplier: 1.0, constant: 0)
        let bottomConst = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: constraintView, attribute: .bottom, multiplier: 1.0, constant: 0)
        let topConst = NSLayoutConstraint(item: constraintView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        self.addConstraints([leftConst, rightConst, topConst, bottomConst])
    }
        

    @IBAction func sendButtonPressed(_ sender: Any) {
        delegate?.sendText(text: textView.text)
        textView.text = ""
    }
    
    public func setButton(text: String) {
        sendButton.titleLabel?.text = text
    }
    
    public func setButtonColor(color: UIColor) {
        sendButton.backgroundColor = color
    }
    
}

extension IMPInputView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
}
