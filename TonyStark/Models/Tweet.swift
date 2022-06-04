//
//  Tweet.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Tweet {
    struct InteractionDetails {
        static func `default`() -> InteractionDetails {
            return InteractionDetails(
                likesCount: 0,
                commentsCount: 0
            )
        }
        
        let likesCount: Int
        let commentsCount: Int
        
        func copyWith(
            likesCount: Int? = nil,
            commentsCount: Int? = nil
        ) -> InteractionDetails {
            let newInteractionDetails = InteractionDetails(
                likesCount: likesCount ?? self.likesCount,
                commentsCount: commentsCount ?? self.commentsCount
            )
            
            return newInteractionDetails
        }
    }

    struct Viewables {
        static func `default`() -> Viewables {
            return Viewables(
                liked: false,
                bookmarked: false
            )
        }
        
        let liked: Bool
        let bookmarked: Bool
        
        func copyWith(
            liked: Bool? = nil,
            bookmarked: Bool? = nil
        ) -> Viewables {
            let newViewables = Viewables(
                liked: liked ?? self.liked,
                bookmarked: bookmarked ?? self.bookmarked
            )
            
            return newViewables
        }
    }

    
    static func `default`() -> Tweet {
        Tweet(
            id: "",
            text: "",
            creationDate: .now(),
            lastUpdatedDate: .now(),
            interactionDetails: .default(),
            author: .default(),
            viewables: .default()
        )
    }
    
    let id: String
    let text: String
    let creationDate: Date
    let lastUpdatedDate: Date
    let interactionDetails: InteractionDetails
    let author: User
    let viewables: Viewables
    
    func copyWith(
        id: String? = nil,
        text: String? = nil,
        creationDate: Date? = nil,
        lastUpdatedDate: Date? = nil,
        interactionDetails: InteractionDetails? = nil,
        author: User? = nil,
        viewables: Viewables? = nil
    ) -> Tweet {
        let newTweet = Tweet(
            id: id ?? self.id,
            text: text ?? self.text,
            creationDate: creationDate ?? self.creationDate,
            lastUpdatedDate: lastUpdatedDate ?? self.lastUpdatedDate,
            interactionDetails: interactionDetails ?? self.interactionDetails,
            author: author ?? self.author,
            viewables: viewables ?? self.viewables
        )
        
        return newTweet
    }
}
