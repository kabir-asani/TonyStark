//
//  Tweet.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Tweet: Model {
    struct InteractionDetails: Model {
        static var `default`: InteractionDetails {
            InteractionDetails(
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
            InteractionDetails(
                likesCount: likesCount ?? self.likesCount,
                commentsCount: commentsCount ?? self.commentsCount
            )
        }
    }

    struct Viewables: Model {
        static var `default`: Viewables {
            Viewables(
                author: .default,
                liked: false,
                bookmarked: false
            )        }
        
        let author: User
        let liked: Bool
        let bookmarked: Bool
        
        func copyWith(
            author: User? = nil,
            liked: Bool? = nil,
            bookmarked: Bool? = nil
        ) -> Viewables {
            Viewables(
                author: author ?? self.author,
                liked: liked ?? self.liked,
                bookmarked: bookmarked ?? self.bookmarked
            )
        }
    }

    
    static var `default`: Tweet {
        Tweet(
            id: "",
            externalId: "",
            text: "",
            creationDate: .current,
            lastUpdatedDate: .current,
            interactionDetails: .default,
            viewables: .default
        )
    }
    
    let id: String
    let externalId: String
    let text: String
    let creationDate: Date
    let lastUpdatedDate: Date
    let interactionDetails: InteractionDetails
    let viewables: Viewables
    
    func copyWith(
        id: String? = nil,
        externalId: String? = nil,
        text: String? = nil,
        creationDate: Date? = nil,
        lastUpdatedDate: Date? = nil,
        interactionDetails: InteractionDetails? = nil,
        viewables: Viewables? = nil
    ) -> Tweet {
        Tweet(
            id: id ?? self.id,
            externalId: externalId ?? self.externalId,
            text: text ?? self.text,
            creationDate: creationDate ?? self.creationDate,
            lastUpdatedDate: lastUpdatedDate ?? self.lastUpdatedDate,
            interactionDetails: interactionDetails ?? self.interactionDetails,
            viewables: viewables ?? self.viewables
        )
    }
}
