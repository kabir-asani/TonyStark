//
//  OtherUserTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/04/22.
//

import UIKit

protocol OtherUserTableViewCellInteractionsHandler: AnyObject {
    func otherUserCellDidPressFollow(_ cell: OtherUserTableViewCell)
    
    func otherUserCellDidPressFollowers(_ cell: OtherUserTableViewCell)
    
    func otherUserCellDidPressFollowings(_ cell: OtherUserTableViewCell)
}

class OtherUserTableViewCell: TXTableViewCell {
    // Declare
    override class var reuseIdentifier: String {
        String(describing: OtherUserTableViewCell.self)
    }
    
    private(set) var user: User!
    
    weak var interactionsHandler: OtherUserTableViewCellInteractionsHandler?
    
    private let header: Header = {
        let header = Header()
        
        header.enableAutolayout()
        
        return header
    }()
    
    private let body: Body = {
        let body = Body()
        
        body.enableAutolayout()
        
        return body
    }()
    
    private let footer: Footer = {
        let footer = Footer()
        
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
    func configure(
        withUser user: User
    ) {
        self.user = user
        
        header.configure(
            withUser: user
        ) {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.otherUserCellDidPressFollow(strongSelf)
        }
        
        body.configure(
            withUser: user
        )
        
        footer.configure(
            withUser: user
        ) {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.otherUserCellDidPressFollowers(
                strongSelf
            )
        } onFollowingsPressed: {
            [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.interactionsHandler?.otherUserCellDidPressFollowings(
                strongSelf
            )
        }
    }
}
