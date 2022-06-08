//
//  SocialsDataTemplate.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 04/06/22.
//

import Foundation

struct FollowerDataTemplate: DataTemplate {
    struct Viewables: Codable {
        let follower: UserDataTemplate
        
        enum ViewablesKey: String, CodingKey {
            case follower
        }
    }
    
    let followerId: String
    let creationDate: String
    let viewables: Viewables
    
    enum FollowerDataTemplateKeys: String, CodingKey {
        case followerId = "follower_id"
        case creationDate = "creation_date"
        case viewables
    }
    
    func model() -> Follower {
        let follower = Follower(
            user: viewables.follower.model(),
            creationDate: .parse(string: creationDate)
        )
        
        return follower
    }
}


struct FolloweeDataTemplate: DataTemplate {
    struct Viewables: Codable {
        let followee: UserDataTemplate
        
        enum ViewablesKey: String, CodingKey {
            case followee
        }
    }
    
    let followeeId: String
    let creationDate: String
    let viewables: Viewables
    
    enum FolloweeDataTemplateKeys: String, CodingKey {
        case followeeId = "followee_id"
        case creationDate = "creation_date"
        case viewables
    }
    
    func model() -> Followee {
        let followee = Followee(
            user: viewables.followee.model(),
            creationDate: .parse(string: creationDate)
        )
        
        return followee
    }
}
