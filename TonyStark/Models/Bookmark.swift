//
//  Bookmark.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Bookmark {
    let id: String
    let authorId: String
    let tweet: Tweet
    
    init(
        id: String,
        authorId: String,
        tweet: Tweet
    ) {
        self.id = id
        self.authorId = authorId
        self.tweet = tweet
    }
    
    func copyWith(
        id: String? = nil,
        authorId: String? = nil,
        tweet: Tweet? = nil
    ) -> Bookmark {
        let newBookmark = Bookmark(
            id: id ?? self.id,
            authorId: authorId ?? self.authorId,
            tweet: tweet ?? self.tweet
        )
        
        return newBookmark
    }
}
