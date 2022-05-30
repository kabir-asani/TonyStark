//
//  Tweet.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Tweet {
    static func `default`() -> Tweet {
        Tweet(
            id: "",
            text: "",
            creationDate: .now(),
            interactionDetails: .default(),
            author: .default(),
            viewables: .default()
        )
    }
    
    let id: String
    let text: String
    let creationDate: Date
    let interactionDetails: TweetInteractionDetails
    let author: User
    let viewables: TweetViewables
    
    func copyWith(
        id: String? = nil,
        text: String? = nil,
        creationDate: Date? = nil,
        interactionDetails: TweetInteractionDetails? = nil,
        author: User? = nil,
        viewables: TweetViewables? = nil
    ) -> Tweet {
        let newTweet = Tweet(
            id: id ?? self.id,
            text: text ?? self.text,
            creationDate: creationDate ?? self.creationDate,
            interactionDetails: interactionDetails ?? self.interactionDetails,
            author: author ?? self.author,
            viewables: viewables ?? self.viewables
        )
        
        return newTweet
    }
}

struct TweetInteractionDetails {
    static func `default`() -> TweetInteractionDetails {
        return TweetInteractionDetails(
            likesCount: 0,
            commentsCount: 0
        )
    }
    
    let likesCount: Int
    let commentsCount: Int
    
    func copyWith(
        likesCount: Int? = nil,
        commentsCount: Int? = nil
    ) -> TweetInteractionDetails {
        let newTweetMeta = TweetInteractionDetails(
            likesCount: likesCount ?? self.likesCount,
            commentsCount: commentsCount ?? self.commentsCount
        )
        
        return newTweetMeta
    }
}

struct TweetViewables {
    static func `default`() -> TweetViewables {
        return TweetViewables(
            liked: false,
            bookmarked: false
        )
    }
    
    let liked: Bool
    let bookmarked: Bool
    
    func copyWith(
        liked: Bool? = nil,
        bookmarked: Bool? = nil
    ) -> TweetViewables {
        let newTweetViewables = TweetViewables(
            liked: liked ?? self.liked,
            bookmarked: bookmarked ?? self.bookmarked
        )
        
        return newTweetViewables
    }
}
