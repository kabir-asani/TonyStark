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

protocol EditBioTableViewCellInteractionsHandler: AnyObject {
    func cell(
        _ cell: EditBioTableViewCell,
        didPressDoneWithUpdatedText text: String
    )
}

class EditBioTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: EditBioTableViewCell.self)
    }
    
    weak var delegate: EditBioTableViewCellDelegate?
    weak var interactionsHandler: EditBioTableViewCellInteractionsHandler?
    
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
    }
    
    private func arrangeBioText() {
        bioText.delegate = self
        
        bioText.pin(
            to: self,
            withInsets: .all(16),
            byBeingSafeAreaAware: true
        )
    }
    
    // Configure
    func configure(withText text: String) {
        bioText.text = text
    }
    
    // Interact
}

extension EditBioTableViewCell: TXTextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
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
