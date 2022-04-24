//
//  OtherUserTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/04/22.
//

import UIKit

protocol OtherUserTableViewCellInteractionsHandler: AnyObject {
    func didPressEdit(_ cell: OtherUserTableViewCell)
    
    func didPressFollowers(_ cell: OtherUserTableViewCell)
    
    func didPressFollowings(_ cell: OtherUserTableViewCell)
}

class OtherUserTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: OtherUserTableViewCell.self)
    }
    
    weak var interactionsHandler: OtherUserTableViewCellInteractionsHandler?
    
    let header: OtherUserTableViewCellHeader = {
        let header = OtherUserTableViewCellHeader()
        
        header.enableAutolayout()
        
        return header
    }()
    
    let body: OtherUserTableViewCellBody = {
        let body = OtherUserTableViewCellBody()
        
        body.enableAutolayout()
        
        return body
    }()
    
    let footer: OtherUserTableViewCellFooter = {
        let footer = OtherUserTableViewCellFooter()
        
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
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.didPressEdit(strongSelf)
        }
        
        body.configure(withUser: user)
        
        footer.configure(
            withUser: user
        ) {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.didPressFollowers(strongSelf)
        } onFollowingsPressed: {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.didPressFollowings(strongSelf)
        }
    }
}
