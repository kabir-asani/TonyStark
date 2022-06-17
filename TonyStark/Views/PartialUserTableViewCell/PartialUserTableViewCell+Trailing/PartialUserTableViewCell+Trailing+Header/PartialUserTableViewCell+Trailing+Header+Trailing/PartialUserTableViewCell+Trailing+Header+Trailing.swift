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
        private var onPrimaryActionPressed: (() -> Void)?
        
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
        func configure(
            withUser user: User,
            onPrimaryActionPressed: @escaping () -> Void
        ) {
            self.onPrimaryActionPressed = onPrimaryActionPressed
            
            if user.id != CurrentUserDataStore.shared.user?.id {
                followButton.setTitle(
                    user.viewables.following
                    ? "Unfollow"
                    : "Follow",
                    for: .normal
                )
            } else {
                followButton.setTitle(
                    "View",
                    for: .normal
                )
            }
            
            
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
            
            followButton.addTarget(
                self,
                action: #selector(onPrimaryActionPressed(_:)),
                for: .touchUpInside
            )
        }
        
        // Interact
        @objc private func onPrimaryActionPressed(
            _ sender: TXButton
        ) {
            onPrimaryActionPressed?()
        }
    }
}
