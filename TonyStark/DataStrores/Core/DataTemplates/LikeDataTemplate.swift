//
//  LikeDataTemplate.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 04/06/22.
//

import Foundation

struct LikeDataTemplate: DataTemplate {
    struct Viewables: Codable {
        let author: UserDataTemplate
        
        enum ViewablesKeys: String, CodingKey {
            case author
        }
    }
    
    let id: String
    let tweetId: String
    let authorId: String
    let creationDate: String
    let viewables: Viewables
    
    enum LikeDataTemplateKeys: String, CodingKey {
        case id
        case tweetId = "tweet_id"
        case authorId = "author_id"
        case creationDate = "creation_date"
        case viewables
    }
    
    func model() -> Like {
        let like = Like(
            id: id,
            tweetId: tweetId,
            creationDate: .parse(string: creationDate),
            author: viewables.author.model()
        )
        
        return like
    }
}
