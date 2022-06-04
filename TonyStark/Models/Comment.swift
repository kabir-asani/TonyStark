//
//  Comment.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//


import Foundation

struct Comment {
    static func `default`() -> Comment {
        Comment(
            id: "", text: "",
            tweetId: "",
            creationDate: .now(),
            author: .default()
        )
    }
    
    let id: String
    let text: String
    let tweetId: String
    let creationDate: Date
    let author: User
    
    func copyWith(
        id: String? = nil,
        text: String? = nil,
        tweetId: String? = nil,
        creationDate: Date? = nil,
        author: User? = nil
    ) -> Comment {
        let newComment = Comment(
            id: id ?? self.id,
            text: text ?? self.text,
            tweetId: tweetId ?? self.tweetId,
            creationDate: creationDate ?? self.creationDate,
            author: author ?? self.author
        )
        
        return newComment
    }
}

