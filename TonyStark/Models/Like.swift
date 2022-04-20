//
//  Like.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Like {
    static func empty() -> Like {
        return Like(
            id: "",
            tweetId: "",
            creationDate: .now(),
            author: .empty()
        )
    }
    
    let id: String
    let tweetId: String
    let creationDate: Date
    let author: User
    
    func copyWith(
        id: String? = nil,
        tweetId: String? = nil,
        creationDate: Date? = nil,
        author: User? = nil
    ) -> Like {
        let newLike = Like(
            id: id ?? self.id,
            tweetId: tweetId ?? self.tweetId,
            creationDate: creationDate ?? self.creationDate,
            author: author ?? self.author
        )
        
        return newLike
    }
}
