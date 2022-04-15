//
//  Like.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Like {
    let id: String
    let tweetId: String
    let author: User
    
    func copyWith(
        id: String? = nil,
        tweetId: String? = nil,
        author: User? = nil
    ) -> Like {
        let newLike = Like(
            id: id ?? self.id,
            tweetId: tweetId ?? self.tweetId,
            author: author ?? self.author
        )
        
        return newLike
    }
}
