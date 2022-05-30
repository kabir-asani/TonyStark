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
            email: "",
            username: "",
            image: "",
            description: "",
            creationDate: .now(),
            socialDetails: .default(),
            activityDetails: .default(),
            viewables: .default()
        )
    }
    
    let id: String
    let name: String
    let email: String
    let username: String
    let image: String
    let description: String
    let creationDate: Date
    let socialDetails: UserSocialDetails
    let activityDetails: UserActivityDetails
    let viewables: UserViewables

    func copyWith(
        id: String? = nil,
        name: String? = nil,
        email: String? = nil,
        username: String? = nil,
        image: String? = nil,
        description: String? = nil,
        creationDate: Date? = nil,
        socialDetails: UserSocialDetails? = nil,
        activityDetails: UserActivityDetails? = nil,
        viewables: UserViewables? = nil
    ) -> User {
        let newUser = User(
            id: id ?? self.id,
            name: name ?? self.name,
            email: email ?? self.email,
            username: username ?? self.username,
            image: image ?? self.image,
            description: description ?? self.description,
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
            followeesCount: 0
        )
    }
    
    let followersCount: Int
    let followeesCount: Int
    
    func copyWith(
        followersCount: Int? = nil,
        followeesCount: Int? = nil
    ) -> UserSocialDetails {
        let newUserSocialDetails = UserSocialDetails(
            followersCount: followersCount ?? self.followersCount,
            followeesCount: followeesCount ?? self.followeesCount
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
        UserViewables(following: false)
    }
    
    let following: Bool
    
    func copyWith(
        follower: Bool? = nil
    ) -> UserViewables {
        let newUserViewables = UserViewables(
            following: follower ?? self.following
        )
        
        return newUserViewables
    }
}
