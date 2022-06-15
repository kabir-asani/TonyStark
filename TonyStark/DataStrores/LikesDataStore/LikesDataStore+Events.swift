//
//  LikesDataStore+Events.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 14/06/22.
//

import Foundation

class LikeCreatedEvent: TXEvent {
    let tweetId: String
    
    init(
        tweetId: String
    ) {
        self.tweetId = tweetId
    }
}

class LikeDeletedEvent: TXEvent {
    let tweetId: String
    
    init(
        tweetId: String
    ) {
        self.tweetId = tweetId
    }
}
