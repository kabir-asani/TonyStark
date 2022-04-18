//
//  CurrentUserDetailsTableViewCellFooter.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import UIKit

class CurrentUserTableViewCellFooter: UIView {
    // Declare
    let followersSocialDetails: SocialDetails = {
        let followersSocialDetails = SocialDetails()
        
        followersSocialDetails.enableAutolayout()
        
        return followersSocialDetails
    }()
    
    let followingsSocialDetails: SocialDetails = {
        let followingsSocialDetails = SocialDetails()
        
        followingsSocialDetails.enableAutolayout()
        
        return followingsSocialDetails
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
        let stack = UIStackView(arrangedSubviews: [
            followersSocialDetails,
            followingsSocialDetails,
            UIStackView.spacer
        ])
        
        stack.enableAutolayout()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fill
        stack.alignment = .center
        
        addSubview(stack)
        
        stack.pin(to: self)
    }
    
    // Configure
    func configure(
        with user: User,
        onFollowersPressed: @escaping () -> Void,
        onFollowingsPressed: @escaping () -> Void
    ) {
        followersSocialDetails.configure(
            with: (
                leadingText: "\(user.socialDetails.followersCount)",
                trailingText: "Followers"
            )
        ) {
            onFollowersPressed()
        }
        
        followingsSocialDetails.configure(
            with: (
                leadingText: "\(user.socialDetails.followingsCount)",
                trailingText: "Followings"
            )
        ) {
            onFollowingsPressed()
        }
    }
}
