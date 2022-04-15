//
//  User.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct User {
    let id: String
    let name: String
    let username: String
    let image: String
    let creationDate: Date
    let socialDetails: UserSocialDetails
    let activityDetails: UserActivityDetails
    let viewables: UserViewables

    func copyWith(
        id: String? = nil,
        name: String? = nil,
        username: String? = nil,
        image: String? = nil,
        creationDate: Date? = nil,
        socialDetails: UserSocialDetails? = nil,
        activityDetails: UserActivityDetails? = nil,
        viewables: UserViewables? = nil
    ) -> User {
        let newUser = User(
            id: id ?? self.id,
            name: name ?? self.name,
            username: username ?? self.username,
            image: image ?? self.image,
            creationDate: creationDate ?? self.creationDate,
            socialDetails: socialDetails ?? self.socialDetails,
            activityDetails: activityDetails ?? self.activityDetails,
            viewables: viewables ?? self.viewables
        )
        
        return newUser
    }
}

struct UserSocialDetails {
    let followersCount: Int
    let followingsCount: Int
    
    func copyWith(
        followersCount: Int? = nil,
        followingsCount: Int? = nil
    ) -> UserSocialDetails {
        let newUserSocialDetails = UserSocialDetails(
            followersCount: followersCount ?? self.followersCount,
            followingsCount: followingsCount ?? self.followingsCount
        )
        
        return newUserSocialDetails
    }
}

struct UserActivityDetails {
    let tweetsCount: Int
    
    func copyWith(
        tweetsCount: Int? = nil
    ) -> UserActivityDetails {
        let newUserActivityDetails = UserActivityDetails(
            tweetsCount: tweetsCount ?? self.tweetsCount
        )
        
        return newUserActivityDetails
    }
}

struct UserViewables {
    let follower: Bool
    
    func copyWith(
        follower: Bool? = nil
    ) -> UserViewables {
        let newUserViewables = UserViewables(
            follower: follower ?? self.follower
        )
        
        return newUserViewables
    }
}
