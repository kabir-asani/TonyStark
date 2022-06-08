//
//  CommentDataTemplate.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 04/06/22.
//

import Foundation

struct CommentDataTemplate: DataTemplate {
    struct Viewables: Codable {
        let author: UserDataTemplate
        
        enum ViewablesKeys: String, CodingKey {
            case author
        }
    }
    
    let id: String
    let tweetId: String
    let authorId: String
    let text: String
    let creationDate: String
    let viewables: Viewables
    
    enum CommentDataTemplateKeys: String, CodingKey {
        case id
        case tweetId = "tweet_id"
        case authorId = "author_id"
        case text
        case creationDate = "creation_date"
        case viewables
    }
    
    func model() -> Comment {
        let comment = Comment(
            id: id,
            text: text,
            tweetId: tweetId,
            creationDate: .parse(string: creationDate),
            author: viewables.author.model()
        )
        
        return comment
    }
}
