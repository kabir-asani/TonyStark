//
//  Bookmark.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Bookmark: Model {
    struct Viewables: Model {
        static var `default`: Viewables {
            Viewables(
                tweet: .default
            )
        }
        
        let tweet: Tweet
        
        func copyWith(
            tweet: Tweet? = nil
        ) -> Viewables {
            Viewables(
                tweet: tweet ?? self.tweet
            )
        }
    }
    
    static var `default`: Bookmark {
        Bookmark(
            id: "",
            authorId: "",
            creationDate: .current,
            viewables: .default
        )
    }
    
    let id: String
    let authorId: String
    let creationDate: Date
    let viewables: Viewables
    
    func copyWith(
        id: String? = nil,
        authorId: String? = nil,
        creationDate: Date? = nil,
        viewables: Viewables? = nil
    ) -> Bookmark {
        Bookmark(
            id: id ?? self.id,
            authorId: authorId ?? self.authorId,
            creationDate: creationDate ?? self.creationDate,
            viewables: viewables ?? self.viewables
        )
    }
}
