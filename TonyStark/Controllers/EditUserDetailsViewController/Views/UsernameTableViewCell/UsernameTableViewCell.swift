//
//  EditUsernameTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 30/04/22.
//

import UIKit

class UsernameTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: UsernameTableViewCell.self)
    }
    
    private let leading: TXLabel = {
        let leading = TXLabel()
        
        leading.enableAutolayout()
        leading.text = "Username"
        leading.numberOfLines = 1
        
        leading.fixWidth(to: 100)
        
        return leading
    }()
    
    private let trailing: TXLabel = {
        let trailing = TXLabel()
        
        trailing.enableAutolayout()
        trailing.numberOfLines = 1
        trailing.lineBreakMode = .byTruncatingTail
        
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
        selectionStyle = .default
    }
    
    private func arrangeSubviews() {
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
    
    // Configure
    func configure(withText text: String) {
        trailing.text = text
    }
    
    // Interact
}
