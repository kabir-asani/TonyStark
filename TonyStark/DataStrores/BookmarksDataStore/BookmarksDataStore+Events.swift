//
//  BookmarksDataStore+Events.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 11/06/22.
//

import Foundation

class CreateBookmarkEvent: TXEvent {
    let bookmark: Bookmark
    
    init(
        bookmark: Bookmark
    ) {
        self.bookmark = bookmark
    }
}

class DeleteBookmarkEvent: TXEvent {
    let bookmarkId: String
    let tweetId: String
    
    init(
        bookmarkId: String,
        tweetId: String
    ) {
        self.bookmarkId = bookmarkId
        self.tweetId = tweetId
    }
}
