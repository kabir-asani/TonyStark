//
//  PartialUserTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import UIKit

protocol PartialUserTableViewCellInteractionsHandler: AnyObject {
    func partialUserCellDidPressProfileImage(_ cell: PartialUserTableViewCell)
}

class PartialUserTableViewCell: TXTableViewCell {
    override class var reuseIdentifier: String {
        String(describing: PartialUserTableViewCell.self)
    }
    
    // Declare
    weak var interactionsHandler: PartialUserTableViewCellInteractionsHandler?
    
    private let leading: Leading = {
        let leading = Leading()
        
        leading.enableAutolayout()
        
        return leading
    }()
    
    private let trailing: Trailing = {
        let trailing = Trailing()
        
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
            withInsets: .symmetric(
                horizontal: 16,
                vertical: 8
            )
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
        leading.configure(withUser: user) {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.partialUserCellDidPressProfileImage(strongSelf)
        }
        
        trailing.configure(withUser: user)
    }
    
    // Interact
}
