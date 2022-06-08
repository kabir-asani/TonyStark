//
//  Comment.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//


import Foundation

struct Comment: Model {
    struct Viewables: Model {
        static var `default`: Viewables {
            Viewables(
                author: .default
            )
        }
        
        let author: User
        
        func copyWith(
            author: User? = nil
        ) -> Viewables {
            Viewables(
                author: author ?? self.author
            )
        }
    }
    
    static var `default`: Comment {
        Comment(
            id: "", text: "",
            tweetId: "",
            creationDate: .current,
            viewables: .default
        )
    }
    
    let id: String
    let text: String
    let tweetId: String
    let creationDate: Date
    let viewables: Viewables
    
    func copyWith(
        id: String? = nil,
        text: String? = nil,
        tweetId: String? = nil,
        creationDate: Date? = nil,
        viewables: Viewables? = nil
    ) -> Comment {
        Comment(
            id: id ?? self.id,
            text: text ?? self.text,
            tweetId: tweetId ?? self.tweetId,
            creationDate: creationDate ?? self.creationDate,
            viewables: viewables ?? self.viewables
        )
    }
}

