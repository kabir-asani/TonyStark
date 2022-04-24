//
//  Bookmark.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Bookmark {
    static func `default`() -> Bookmark {
        Bookmark(
            id: "",
            authorId: "",
            creationDate: .now(),
            tweet: .default()
        )
    }
    
    let id: String
    let authorId: String
    let creationDate: Date
    let tweet: Tweet
    
    func copyWith(
        id: String? = nil,
        authorId: String? = nil,
        creationDate: Date? = nil,
        tweet: Tweet? = nil
    ) -> Bookmark {
        let newBookmark = Bookmark(
            id: id ?? self.id,
            authorId: authorId ?? self.authorId,
            creationDate: creationDate ?? self.creationDate,
            tweet: tweet ?? self.tweet
        )
        
        return newBookmark
    }
}
