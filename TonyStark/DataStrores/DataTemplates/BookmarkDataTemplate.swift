//
//  BookmarkDataTemplate.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 04/06/22.
//

import Foundation

struct BookmarkDataTemplate: DataTemplate {
    struct Viewables: Codable {
        let tweet: TweetDataTemplate
        
        enum ViewablesKeys: String, CodingKey {
            case tweet
        }
    }
   
    let id: String
    let tweetId: String
    let authorId: String
    let creationDate: String
    let viewables: Viewables
    
    enum BookmarkDataTemplateKeys: String, CodingKey {
        case id
        case tweetId = "tweet_id"
        case authorId = "author_id"
        case creationDate = "creation_date"
        case viewables
    }
    
    func model() -> Bookmark {
        let bookmark = Bookmark(
            id: id,
            authorId: authorId,
            creationDate: .parse(string: creationDate),
            tweet: viewables.tweet.model()
        )
        
        return bookmark
    }
}
