//
//  CurrentUserDetailsTableViewCellFooter.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 18/04/22.
//

import UIKit

protocol CurrentUserTableViewCellFooterInteractionsHandler: AnyObject {
    func didPressFollowers(_ currentUserTableViewCellFooter: CurrentUserTableViewCellFooter)
    
    func didPressFollowings(_ currentUserTableViewCellFooter: CurrentUserTableViewCellFooter)
}

class CurrentUserTableViewCellFooter: TXView {
    private enum SocialDetailsIdentifier: String {
        case followers = "follower"
        case followings = "followings"
    }
    
    // Declare
    weak var interactionsHandler: CurrentUserTableViewCellFooterInteractionsHandler?
    
    let followersSocialDetails: SocialDetails = {
        let followersSocialDetails = SocialDetails()
        
        followersSocialDetails.identifier = SocialDetailsIdentifier.followers.rawValue
        
        followersSocialDetails.enableAutolayout()
        
        return followersSocialDetails
    }()
    
    let followingsSocialDetails: SocialDetails = {
        let followingsSocialDetails = SocialDetails()
        
        followingsSocialDetails.identifier = SocialDetailsIdentifier.followings.rawValue
        
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
        let combinedStackView = makeCombinedStackView()
        
        addSubview(combinedStackView)
        
        combinedStackView.pin(to: self)
    }
    
    private func makeCombinedStackView() -> TXStackView {
        let combinedStack = TXStackView(
            arrangedSubviews: [
                followersSocialDetails,
                followingsSocialDetails,
                TXStackView.spacer,
            ]
        )
        
        combinedStack.enableAutolayout()
        combinedStack.axis = .horizontal
        combinedStack.spacing = 8
        combinedStack.distribution = .fill
        combinedStack.alignment = .center
        
        return combinedStack
    }
    
    // Configure
    func configure(
        withUser user: User
    ) {
        followersSocialDetails.interactionsHandler = self
        followersSocialDetails.configure(
            withData: (
                leadingText: "\(user.socialDetails.followersCount)",
                trailingText: "Followers"
            )
        )
        
        followingsSocialDetails.interactionsHandler = self
        followingsSocialDetails.configure(
            withData: (
                leadingText: "\(user.socialDetails.followingsCount)",
                trailingText: "Followings"
            )
        )
    }
}

// MARK: SocialDetailsInteractionHandler
extension CurrentUserTableViewCellFooter: SocialDetailsInteractionsHandler {
    func didPress(_ socialDetails: SocialDetails) {
        if let identifier = socialDetails.identifier {
            if identifier == SocialDetailsIdentifier.followers.rawValue {
                interactionsHandler?.didPressFollowers(self)
            }
            
            if identifier == SocialDetailsIdentifier.followings.rawValue {
                interactionsHandler?.didPressFollowings(self)
            }
        }
    }
}
