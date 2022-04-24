//
//  User.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct User {
    static func `default`() -> User {
        User(
            id: "",
            name: "",
            username: "",
            image: "",
            bio: "",
            creationDate: .now(),
            socialDetails: .default(),
            activityDetails: .default(),
            viewables: .default()
        )
    }
    
    let id: String
    let name: String
    let username: String
    let image: String
    let bio: String
    let creationDate: Date
    let socialDetails: UserSocialDetails
    let activityDetails: UserActivityDetails
    let viewables: UserViewables

    func copyWith(
        id: String? = nil,
        name: String? = nil,
        username: String? = nil,
        image: String? = nil,
        bio: String? = nil,
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
            bio: bio ?? self.bio,
            creationDate: creationDate ?? self.creationDate,
            socialDetails: socialDetails ?? self.socialDetails,
            activityDetails: activityDetails ?? self.activityDetails,
            viewables: viewables ?? self.viewables
        )
        
        return newUser
    }
}

struct UserSocialDetails {
    static func `default`() -> UserSocialDetails {
        UserSocialDetails(
            followersCount: 0,
            followingsCount: 0
        )
    }
    
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
    static func `default`() -> UserActivityDetails {
        UserActivityDetails(tweetsCount: 0)
    }
    
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
    static func `default`() -> UserViewables {
        UserViewables(follower: false)
    }
    
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
