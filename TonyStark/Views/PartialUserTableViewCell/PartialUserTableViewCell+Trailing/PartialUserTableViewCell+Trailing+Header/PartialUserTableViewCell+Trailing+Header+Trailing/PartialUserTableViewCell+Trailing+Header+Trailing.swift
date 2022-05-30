//
//  PartialUserTableViewCellTrailingHeaderFooter.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import UIKit

extension PartialUserTableViewCell.Trailing.Header {
    class Trailing: TXView {
        // Declare
        private let followButton: TXButton = {
            let followButton = TXButton()
            
            followButton.enableAutolayout()
            followButton.fixWidth(to: 100)
            followButton.fixHeight(to: 40)
            
            followButton.layer.cornerRadius = 22
            followButton.clipsToBounds = true
            
            return followButton
        }()
        
        // Arrange
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            arrangeSubviews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func arrangeSubviews() {
            addSubview(followButton)
            
            followButton.pin(to: self)
        }
        
        // Configure
        func configure(withUser user: User) {
            followButton.setTitle(
                user.viewables.following
                ? "Unfollow"
                : "Follow",
                for: .normal
            )
            
            if #available(iOS 15.0, *) {
                followButton.setTitleColor(
                    user.viewables.following
                    ? .label
                    : .systemBlue,
                    for: .normal
                )
                followButton.setTitleColor(
                    user.viewables.following
                    ? .systemGray
                    : .systemBlue,
                    for: .highlighted
                )
                followButton.configuration = TXButton.Configuration.bordered()
            } else {
                followButton.setTitleColor(
                    user.viewables.following
                    ? .label
                    : .systemBlue,
                    for: .normal
                )
                followButton.layer.borderWidth = 2
                followButton.layer.borderColor = user.viewables.following
                ? TXColor.systemGray.cgColor
                : TXColor.systemBlue.cgColor
                followButton.showsTouchWhenHighlighted = true
            }
        }
        
        // Interact
    }
}
