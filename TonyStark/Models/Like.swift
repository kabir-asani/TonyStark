//
//  Like.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation
import CoreImage

struct Like: Model {
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
    
    static var `default`: Like {
        Like(
            id: "",
            tweetId: "",
            creationDate: .current,
            viewables: .default
        )
    }
    
    let id: String
    let tweetId: String
    let creationDate: Date
    let viewables: Viewables
    
    func copyWith(
        id: String? = nil,
        tweetId: String? = nil,
        creationDate: Date? = nil,
        viewables: Viewables? = nil
    ) -> Like {
        Like(
            id: id ?? self.id,
            tweetId: tweetId ?? self.tweetId,
            creationDate: creationDate ?? self.creationDate,
            viewables: viewables ?? self.viewables
        )
    }
}
