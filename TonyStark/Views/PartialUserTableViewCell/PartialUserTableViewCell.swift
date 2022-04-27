//
//  PartialUserTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import UIKit

class PartialUserTableViewCell: TXTableViewCell {
    override class var reuseIdentifier: String {
        String(describing: PartialUserTableViewCell.self)
    }
    
    // Declare
    private let leading: PartialUserTableViewCellLeading = {
        let leading = PartialUserTableViewCellLeading()
        
        leading.enableAutolayout()
        
        return leading
    }()
    
    private let trailing: PartialUserTableViewCellTrailing = {
        let trailing = PartialUserTableViewCellTrailing()
        
        trailing.enableAutolayout()
        
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
        combinedStack.alignment = .top
        combinedStack.spacing = 16
        
        return combinedStack
    }
    
    // Configure
    func configure(withUser user: User) {
        leading.configure(withUser: user)
        trailing.configure(withUser: user)
    }
    
    // Interact
}