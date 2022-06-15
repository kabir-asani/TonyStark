//
//  EditUsernameTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 02/05/22.
//

import UIKit

protocol EditUsernameTableViewCellDelegate: AnyObject {
    func cell(
        _ cell: EditUsernameTableViewCell,
        didChangeText text: String
    )
}

protocol EditUsernameTableViewCellInteractionsHandler: AnyObject {
    func cell(
        _ cell: EditUsernameTableViewCell,
        didEndEditingWithText text: String
    )
}

class EditUsernameTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: EditUsernameTableViewCell.self)
    }
    
    weak var delegate: EditUsernameTableViewCellDelegate?
    weak var interactionsHandler: EditUsernameTableViewCellInteractionsHandler?
    
    private let usernameText: TXTextField = {
        let usernameText = TXTextField()
        
        usernameText.enableAutolayout()
        usernameText.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        usernameText.backgroundColor = .clear
        usernameText.returnKeyType = .done
        usernameText.autocapitalizationType = .none
        usernameText.placeholder = "Add your username"
        
        return usernameText
    }()
    
    // Arrange
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        arrangeBaseView()
        arrangeSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func arrangeBaseView() {
        selectionStyle = .none
        separatorInset = .leading(.infinity)
    }
    
    private func arrangeSubviews() {
        addSubview(usernameText)
        
        arrangeUsernameText()
    }
    
    private func arrangeUsernameText() {
        usernameText.delegate = self
        
        usernameText.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        
        usernameText.pin(
            to: self,
            withInsets: .all(16),
            byBeingSafeAreaAware: true
        )
    }
    
    // Configure
    func configure(withText text: String) {
        usernameText.text = text
    }
    
    // Interact
}

extension EditUsernameTableViewCell: TXTextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.cell(
                self,
                didChangeText: text
            )
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            interactionsHandler?.cell(
                self,
                didEndEditingWithText: text
            )
        }
    }
}

