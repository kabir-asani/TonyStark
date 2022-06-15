//
//  BookmarksDataStore+Events.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 11/06/22.
//

import Foundation

class BookmarkCreatedEvent: TXEvent {
    let tweetId: String

    init(
        tweetId: String
    ) {
        self.tweetId = tweetId
    }
}

class BookmarkDeletedEvent: TXEvent {
    let tweetId: String
    
    init(
        tweetId: String
    ) {
        self.tweetId = tweetId
    }
}
