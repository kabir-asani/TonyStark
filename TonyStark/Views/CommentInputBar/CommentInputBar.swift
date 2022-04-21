//
//  CommentInputBarView.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 21/04/22.
//

import UIKit

class CommentInputBar: TXView {
    // Declare
    private var onPressed: ((_ text: String) -> Void)?
    
    private let textField: TXTextField = {
        let textField = TXTextField()
        
        textField.enableAutolayout()
        
        return textField
    }()
    
    private let primaryButton: TXButton = {
        let primaryButton = TXButton(type: .system)
        
        primaryButton.enableAutolayout()
        primaryButton.setTitleColor(
            .systemPurple,
            for: .normal
        )
        primaryButton.setTitleColor(
            .systemPurple.withAlphaComponent(0.8),
            for: .highlighted
        )
        primaryButton.setTitleColor(
            .systemGray,
            for: .disabled
        )
        primaryButton.isEnabled = false
        
        return primaryButton
    }()
    
    // Arrange
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeSubviews() {
        addSubview(textField)
        addSubview(primaryButton)
        
        arrangeTextField()
        arrangePrimaryButton()
    }
    
    private func arrangeTextField() {
        textField.delegate = self
        
        textField.pin(toTopOf: self)
        textField.pin(toBottomOf: self)
        textField.pin(toLeftOf: self)
        
        textField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
    }
    
    private func arrangePrimaryButton() {
        primaryButton.fixWidth(to: 40)
        
        primaryButton.pin(toTopOf: self)
        primaryButton.pin(toBottomOf: self)
        primaryButton.pin(toRightOf: self)
        primaryButton.attach(
            leftToRightOf: textField,
            withMargin: 8
        )
    }
    
    // Configure
    func configure(
        withData data: (
            inputPlaceholder: String,
            buttonText: String
        ),
        onPressed: @escaping (_ text: String) -> Void
    ) {
        self.onPressed = onPressed
        
        textField.placeholder = data.inputPlaceholder
        primaryButton.setTitle(
            data.buttonText,
            for: .normal
        )
    }
    
    // Interact
    @objc private func onPrimaryPressed(_ sender: TXButton) {
        onPressed?(textField.text ?? "")
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            primaryButton.isEnabled = true
        } else {
            primaryButton.isEnabled = false
        }
    }
}

extension CommentInputBar: TXTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
    }
}
