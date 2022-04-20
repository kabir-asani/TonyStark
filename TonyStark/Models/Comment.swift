//
//  Comment.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//


import Foundation

struct Comment {
    let id: String
    let text: String
    let tweetId: String
    let author: User
    let creationDate: Date
    
    func copyWith(
        id: String? = nil,
        text: String? = nil,
        tweetId: String? = nil,
        author: User? = nil,
        creationDate: Date? = nil
    ) -> Comment {
        let newComment = Comment(
            id: id ?? self.id,
            text: text ?? self.text,
            tweetId: tweetId ?? self.tweetId,
            author: author ?? self.author,
            creationDate: creationDate ?? self.creationDate
        )
        
        return newComment
    }
}

