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
        separatorInset = .empty
    }
    
    private func arrangeSubviews() {
        let combinedStackView = makeCombinedStackView()
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(
            to: self,
            withInsets: TXEdgeInsets(
                top: 16,
                right: 16,
                bottom: 16,
                left: 16
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
        header.configure(
            withUser: user
        ) {
            [weak self] in
            guard let safeSelf = self else {
                return
            }
            
            safeSelf.interactionsHandler?.didPressEdit(safeSelf)
        }
        
        body.configure(withUser: user)
        
        footer.configure(
            withUser: user
        ) {
            [weak self] in
            guard let safeSelf = self else {
                return
            }
            
            safeSelf.interactionsHandler?.didPressFollowers(safeSelf)
        } onFollowingsPressed: {
            [weak self] in
            guard let safeSelf = self else {
                return
            }
            
            safeSelf.interactionsHandler?.didPressFollowings(safeSelf)
        }
    }
}
