//
//  EditNameTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 30/04/22.
//

import UIKit

protocol NameTableViewCellDelegate: AnyObject {
    func nameCell(
        _ cell: NameTableViewCell,
        didChangeName name: String
    )
}

class NameTableViewCell: TXTableViewCell {
    // Declare
    weak var delegate: NameTableViewCellDelegate?
    
    override class var reuseIdentifier: String {
        String(describing: NameTableViewCell.self)
    }
    
    private let leading: TXLabel = {
        let leading = TXLabel()
        
        leading.enableAutolayout()
        leading.text = "Name"
        leading.numberOfLines = 1
        
        leading.fixWidth(to: 100)
        
        return leading
    }()
    
    private let trailing: TXTextField = {
        let trailing = TXTextField()
        
        trailing.enableAutolayout()
        trailing.placeholder = "Add your name"
        
        return trailing
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
    }
    
    private func arrangeSubviews() {
        arrangeTrailing()
        
        let combinedStackView = makeCombinedStackView()
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(
            to: self,
            withInsets: .all(16)
        )
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                leading,
                trailing
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .horizontal
        combinedStack.distribution = .fill
        combinedStack.alignment = .center
        combinedStack.spacing = 16
        
        return combinedStack
    }
    
    private func arrangeTrailing() {
        trailing.delegate = self
        
        trailing.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
    }
    
    // Configure
    func configure(withText text: String) {
        trailing.text = text
    }
    
    // Interact
}

// MARK: TXTextFieldDelegate
extension NameTableViewCell: TXTextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.nameCell(
                self,
                didChangeName: text
            )
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.nameCell(
                self,
                didChangeName: text
            )
        }
    }
}

