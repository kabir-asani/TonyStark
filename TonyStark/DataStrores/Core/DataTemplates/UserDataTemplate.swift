//
//  UserDataTemplate.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 04/06/22.
//

import Foundation

struct UserDataTemplate: DataTemplate {
    struct SocialDetails: Codable {
        let followersCount: Int
        let followeesCount: Int
        
        enum SocialDetailsKeys: String, CodingKey {
            case followersCount = "followers_count"
            case followeesCount = "followees_count"
        }
    }
    
    struct ActivityDetails: Codable {
        let tweetsCount: Int
        
        enum ActivityDetailsKeys: String, CodingKey {
            case tweetsCount = "tweets_count"
        }
    }
    
    struct Viewables: Codable {
        let following: Bool
        
        enum ViewablesKeys: String, CodingKey {
            case following
        }
    }
    
    let id: String
    let name: String
    let email: String
    let username: String
    let description: String
    let image: String
    let creationDate: String
    let lastUpdatedDate: String
    let socialDetails: SocialDetails
    let activityDetails: ActivityDetails
    let viewables: Viewables
    
    enum UserDataTemplateKeys: String, CodingKey {
        case id
        case name
        case email
        case username
        case description
        case image
        case creationDate = "creation_date"
        case lastUpdatedDate = "last_updated_date"
        case socialDetails = "social_details"
        case activityDetails = "activity_details"
        case viewables
    }
    
    func model() -> User {
        let user = User(
            id: id,
            name: name,
            email: email,
            username: username,
            image: image,
            description: description,
            creationDate: .parse(string: creationDate),
            lastUpdatedDate: .parse(string: lastUpdatedDate),
            socialDetails: .init(
                followersCount: socialDetails.followersCount,
                followeesCount: socialDetails.followeesCount
            ),
            activityDetails: .init(
                tweetsCount: activityDetails.tweetsCount
            ),
            viewables: .init(
                following: viewables.following
            )
        )
        
        return user
    }
}

