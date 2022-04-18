//
//  ProfileTableViewCell.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 17/04/22.
//

import UIKit

protocol CurrentUserTableViewCellDelegate: AnyObject {
    func didPressEdit(_ cell: CurrentUserTableViewCell)
    
    func didPressFollowers(_ cell: CurrentUserTableViewCell)
    
    func didPressFollowings(_ cell: CurrentUserTableViewCell)
}

class CurrentUserTableViewCell: TXTableViewCell {
    // Declare
    static let reuseIdentifier = String(describing: CurrentUserTableViewCell.self)
    
    weak var delegate: CurrentUserTableViewCellDelegate?
    
    
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
            
            safeSelf.delegate?.didPressEdit(safeSelf)
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
            
            safeSelf.delegate?.didPressFollowers(safeSelf)
        } onFollowingsPressed: {
            [weak self] in
            
            guard let safeSelf = self else {
                return
            }
            
            safeSelf.delegate?.didPressFollowings(safeSelf)
        }
    }
}

