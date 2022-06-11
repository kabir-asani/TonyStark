//
//  EdtiBioTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 02/05/22.
//

import UIKit

protocol EditBioTableViewCellDelegate: AnyObject {
    func cell(
        _ cell: EditBioTableViewCell,
        didChangeText text: String
    )
}

class EditBioTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: EditBioTableViewCell.self)
    }
    
    weak var delegate: EditBioTableViewCellDelegate?
    
    private let bioText: TXTextView = {
        let bioText = TXTextView()
        
        bioText.enableAutolayout()
        bioText.isScrollEnabled = false
        bioText.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        bioText.backgroundColor = .clear
        
        return bioText
    }()
    
    private let placeholderLabel : TXLabel = {
        let placeholderLabel = TXLabel()
        
        placeholderLabel.enableAutolayout()
        placeholderLabel.sizeToFit()
        placeholderLabel.font = .systemFont(
            ofSize: 16,
            weight: .regular
        )
        placeholderLabel.textColor = .systemGray
        placeholderLabel.text = "Add a bio to your profile..."
        
        return placeholderLabel
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
        addSubview(bioText)
        
        arrangeBioText()
        arrangePlaceholderLabel()
    }
    
    private func arrangeBioText() {
        bioText.delegate = self
        
        bioText.pin(
            to: self,
            withInsets: .all(16),
            byBeingSafeAreaAware: true
        )
    }
    
    private func arrangePlaceholderLabel() {
        bioText.addSubview(placeholderLabel)
        
        placeholderLabel.pin(
            toLeftOf: bioText,
            withInset: 5
        )
        placeholderLabel.pin(
            toTopOf: bioText,
            withInset: 8
        )
    }
    
    // Configure
    func configure(
        withText text: String
    ) {
        bioText.text = text
        
        if !text.isEmpty {
            placeholderLabel.isHidden = true
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        bioText.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        bioText.resignFirstResponder()
    }
    
    // Interact
}

extension EditBioTableViewCell: TXTextViewDelegate {
    func textViewDidChange(
        _ textView: UITextView
    ) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        delegate?.cell(
            self,
            didChangeText: textView.text
        )
    }
    
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String
    ) -> Bool {
        let currentText = textView.text! as String
        let updatedText = (currentText as NSString).replacingCharacters(
            in: range,
            with: text
        )
        
        if updatedText.count <= 120 && updatedText.count(ofCharacter: "\n") <= 6 {
            return true
        } else {
            return false
        }
    }
}
