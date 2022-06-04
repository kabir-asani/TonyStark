//
//  TweetDataTemplate.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 04/06/22.
//

import Foundation

struct TweetDataTemplate: DataTemplate {
    struct InteractionDetails: Codable {
        let likesCount: Int
        let commentsCount: Int
        
        enum InteractionDetailsKeys: String, CodingKey {
            case likesCount = "likes_count"
            case commentsCount = "comments_count"
        }
    }
    
    struct Viewables: Codable {
        let author: UserDataTemplate
        let bookmarked: Bool
        let liked: Bool
        
        enum ViewablesKeys: String, CodingKey {
            case author
            case bookmarked
            case liked
        }
    }
    
    let id: String
    let externalId: String
    let text: String
    let creationDate: String
    let lastUpdatedDate: String
    let interactionDetails: InteractionDetails
    let viewables: Viewables
    
    enum TweetDataTemplateKeys: String, CodingKey {
        case id
        case externalId = "external_id"
        case text
        case creationDate = "creationDate"
        case lastUpdatedDate = "last_updated_date"
        case interactionDetails = "interaction_details"
        case viewables
    }
    
    func model() -> Tweet {
        let tweet = Tweet(
            id: id,
            text: text,
            creationDate: .parse(string: creationDate),
            lastUpdatedDate: .parse(string: lastUpdatedDate),
            interactionDetails: .init(
                likesCount: interactionDetails.likesCount,
                commentsCount: interactionDetails.commentsCount
            ),
            author: viewables.author.model(),
            viewables: .init(
                liked: viewables.liked,
                bookmarked: viewables.bookmarked
            )
        )
        
        return tweet
    }
}
