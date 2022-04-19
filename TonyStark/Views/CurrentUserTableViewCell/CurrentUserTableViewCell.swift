//
//  ProfileTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 17/04/22.
//

import UIKit

protocol CurrentUserTableViewCellInteractionsHandler: AnyObject {
    func didPressEdit(_ cell: CurrentUserTableViewCell)
    
    func didPressFollowers(_ cell: CurrentUserTableViewCell)
    
    func didPressFollowings(_ cell: CurrentUserTableViewCell)
}

class CurrentUserTableViewCell: TXTableViewCell {
    // Declare
    static let reuseIdentifier = String(describing: CurrentUserTableViewCell.self)
    
    weak var interactionsHandler: CurrentUserTableViewCellInteractionsHandler?
    
    let header: CurrentUserTableViewCellHeader = {
        let header = CurrentUserTableViewCellHeader()
        
        header.enableAutolayout()
        
        return header
    }()
    
    let body: CurrentUserTableViewCellBody = {
        let body = CurrentUserTableViewCellBody()
        
        body.enableAutolayout()
        
        return body
    }()
    
    let footer: CurrentUserTableViewCellFooter = {
        let footer = CurrentUserTableViewCellFooter()
        
        footer.enableAutolayout()
        
        return footer
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
        separatorInset = UIEdgeInsets(
            top: 0,
            left: Double.infinity,
            bottom: 0,
            right: 0
        )
    }
    
    private func arrangeSubviews() {
        let combinedStackView = makeCombinedStackView()
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(
            to: self,
            padding: UIEdgeInsets(
                top: 16,
                left: 16,
                bottom: -16,
                right: -16
            )
        )
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                header,
                body,
                footer
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .vertical
        combinedStack.distribution = .equalSpacing
        combinedStack.spacing = 16
        
        return combinedStack
    }
    
    // Configure
    func configure(withUser user: User) {
        header.interactionsHandler = self
        header.configure(withUser: user)
        
        body.configure(withUser: user)
        
        footer.interactionsHandler = self
        footer.configure(withUser: user)
    }
}

// MARK: CurrentUserTableViewCellHeaderInteractionHandler
extension CurrentUserTableViewCell: CurrentUserTableViewCellHeaderInteractionsHandler {
    func didPressEdit(
        _ currentUserTableViewCellHeader: CurrentUserTableViewCellHeader
    ) {
        interactionsHandler?.didPressEdit(self)
    }
}

// MARK: CurrentUserTableViewCellFooterInteractionHandler
extension CurrentUserTableViewCell: CurrentUserTableViewCellFooterInteractionsHandler {
    func didPressFollowers(
        _ currentUserTableViewCellFooter: CurrentUserTableViewCellFooter
    ) {
        interactionsHandler?.didPressFollowers(self)
    }
    
    func didPressFollowings(
        _ currentUserTableViewCellFooter: CurrentUserTableViewCellFooter
    ) {
        interactionsHandler?.didPressFollowings(self)
    }
}
