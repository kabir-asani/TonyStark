//
//  ProfileTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 17/04/22.
//

import UIKit

protocol CurrentUserDetailsTableViewCellDelegate: AnyObject {
    func onEditPressed()
    
    func onFollowersPressed()
    
    func onFollowingsPressed()
}

class CurrentUserDetailsTableViewCell: TXTableViewCell {
    // Declare
    static let reuseIdentifier = String(describing: CurrentUserDetailsTableViewCell.self)
    
    weak var delegate: CurrentUserDetailsTableViewCellDelegate?
    
    let header: CurrentUserDetailsTableViewCellHeader = {
        let header = CurrentUserDetailsTableViewCellHeader()
        
        header.enableAutolayout()
        
        return header
    }()
    
    let body: CurrentUserDetailsTableViewCellBody = {
        let body = CurrentUserDetailsTableViewCellBody()
        
        body.enableAutolayout()
        
        return body
    }()
    
    let footer: CurrentUserDetailsTableViewCellFooter = {
        let footer = CurrentUserDetailsTableViewCellFooter()
        
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
        let stack = UIStackView(arrangedSubviews: [
            header,
            body,
            footer
        ])
        
        stack.enableAutolayout()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.spacing = 16
        
        addSubview(stack)
        
        stack.pin(
            to: self,
            padding: UIEdgeInsets(
                top: 16,
                left: 16,
                bottom: -16,
                right: -16
            )
        )
    }
    
    // Configure
    func configure(with user: User) {
        header.configure(
            with: user
        ) {
            [weak self] in
            guard let safeSelf = self else {
                return
            }
            
            safeSelf.delegate?.onEditPressed()
        }
        
        body.configure(
            with: user
        )
        
        footer.configure(
            with: user
        ) {
            [weak self] in
            
            guard let safeSelf = self else {
                return
            }
            
            safeSelf.delegate?.onFollowersPressed()
        } onFollowingsPressed: {
            [weak self] in
            
            guard let safeSelf = self else {
                return
            }
            
            safeSelf.delegate?.onFollowingsPressed()
        }
    }
}

