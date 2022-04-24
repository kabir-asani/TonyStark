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
            creationDate: .now(),
            tweetId: "",
            author: .default()
        )
    }
    
    let id: String
    let text: String
    let creationDate: Date
    let tweetId: String
    let author: User
    
    func copyWith(
        id: String? = nil,
        text: String? = nil,
        creationDate: Date? = nil,
        tweetId: String? = nil,
        author: User? = nil
    ) -> Comment {
        let newComment = Comment(
            id: id ?? self.id,
            text: text ?? self.text,
            creationDate: creationDate ?? self.creationDate,
            tweetId: tweetId ?? self.tweetId,
            author: author ?? self.author
        )
        
        return newComment
    }
}

