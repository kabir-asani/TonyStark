//
//  CurrentUser.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 30/05/22.
//

import Foundation

struct CurrentUser {
    static func `default`() -> CurrentUser {
        CurrentUser(
            id: "",
            name: "",
            email: "",
            username: "",
            image: "",
            description: "",
            creationDate: .now(),
            socialDetails: .default(),
            activityDetails: .default()
        )
    }
    
    let id: String
    let name: String
    let email: String
    let username: String
    let image: String
    let description: String
    let creationDate: Date
    let socialDetails: CurrentUserSocialDetails
    let activityDetails: CurrentUserActivityDetails
}

struct CurrentUserSocialDetails {
    static func `default`() -> CurrentUserSocialDetails {
        CurrentUserSocialDetails(
            followersCount: 0,
            followeesCount: 0
        )
    }
    
    let followersCount: Int
    let followeesCount: Int
    
    func copyWith(
        followersCount: Int? = nil,
        followeesCount: Int? = nil
    ) -> CurrentUserSocialDetails {
        let newUserSocialDetails = CurrentUserSocialDetails(
            followersCount: followersCount ?? self.followersCount,
            followeesCount: followeesCount ?? self.followeesCount
        )
        
        return newUserSocialDetails
    }
}

struct CurrentUserActivityDetails {
    static func `default`() -> CurrentUserActivityDetails {
        CurrentUserActivityDetails(tweetsCount: 0)
    }
    
    let tweetsCount: Int
    
    func copyWith(
        tweetsCount: Int? = nil
    ) -> CurrentUserActivityDetails {
        let newUserActivityDetails = CurrentUserActivityDetails(
            tweetsCount: tweetsCount ?? self.tweetsCount
        )
        
        return newUserActivityDetails
    }
}
