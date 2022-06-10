//
//  TweetsDataStore+Events.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 09/06/22.
//

import Foundation

class TweetCreatedEvent: TXEvent {
    let tweet: Tweet
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
}

class TweetDeletedEvent: TXEvent {
    let id: String
    
    init(id: String) {
        self.id = id
    }
}
