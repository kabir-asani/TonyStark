//
//  BookmarksDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import Foundation

class BookmarksDataStore: DataStore {
    static let shared = BookmarksDataStore()
    
    private init() { }
    
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }
    
    func bookmark(tweetWithId tweetId: String) async -> Result<Void, BookmarkFailure> {
        return .failure(.unknown)
    }
    
    func unbookmark(tweetWithId tweetId: String) async -> Result<Void, UnbookmarkFailure> {
        return .failure(.unknown)
    }
    
    func bookmarks(
        after nextToken: String? = nil
    ) async -> Result<Paginated<Bookmark>, BookmarksFailure> {
        return .failure(.unknown)
    }
}
