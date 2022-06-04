//
//  User.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct User {
    struct SocialDetails {
        static func `default`() -> SocialDetails {
            SocialDetails(
                followersCount: 0,
                followeesCount: 0
            )
        }
        
        let followersCount: Int
        let followeesCount: Int
        
        func copyWith(
            followersCount: Int? = nil,
            followeesCount: Int? = nil
        ) -> SocialDetails {
            let newSocialDetails = SocialDetails(
                followersCount: followersCount ?? self.followersCount,
                followeesCount: followeesCount ?? self.followeesCount
            )
            
            return newSocialDetails
        }
    }

    struct ActivityDetails {
        static func `default`() -> ActivityDetails {
            User.ActivityDetails(tweetsCount: 0)
        }
        
        let tweetsCount: Int
        
        func copyWith(
            tweetsCount: Int? = nil
        ) -> ActivityDetails {
            let newActivityDetails = ActivityDetails(
                tweetsCount: tweetsCount ?? self.tweetsCount
            )
            
            return newActivityDetails
        }
    }

    struct Viewables {
        static func `default`() -> User.Viewables {
            User.Viewables(following: false)
        }
        
        let following: Bool
        
        func copyWith(
            follower: Bool? = nil
        ) -> User.Viewables {
            let newViewables = User.Viewables(
                following: follower ?? self.following
            )
            
            return newViewables
        }
    }

    static func `default`() -> User {
        User(
            id: "",
            name: "",
            email: "",
            username: "",
            image: "",
            description: "",
            creationDate: .now(),
            lastUpdatedDate: .now(),
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
    let lastUpdatedDate: Date
    let socialDetails: SocialDetails
    let activityDetails: ActivityDetails
    let viewables: Viewables

    func copyWith(
        id: String? = nil,
        name: String? = nil,
        email: String? = nil,
        username: String? = nil,
        image: String? = nil,
        description: String? = nil,
        creationDate: Date? = nil,
        lastUpdatedDate: Date? = nil,
        socialDetails: SocialDetails? = nil,
        activityDetails: ActivityDetails? = nil,
        viewables: Viewables? = nil
    ) -> User {
        let newUser = User(
            id: id ?? self.id,
            name: name ?? self.name,
            email: email ?? self.email,
            username: username ?? self.username,
            image: image ?? self.image,
            description: description ?? self.description,
            creationDate: creationDate ?? self.creationDate,
            lastUpdatedDate: lastUpdatedDate ?? self.lastUpdatedDate,
            socialDetails: socialDetails ?? self.socialDetails,
            activityDetails: activityDetails ?? self.activityDetails,
            viewables: viewables ?? self.viewables
        )
        
        return newUser
    }
}
