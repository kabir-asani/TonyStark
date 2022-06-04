//
//  BookmarksDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import Foundation

protocol BookmarksDataStoreProtocol: DataStoreProtocol {
    func bookmark(tweetWithId tweetId: String) async -> Result<Void, BookmarkFailure>
    
    func unbookmark(tweetWithId tweetId: String) async -> Result<Void, UnbookmarkFailure>
    
    func bookmarks() async -> Result<Paginated<Bookmark>, BookmarksFailure>
    
    func bookmarks(after nextToken: String) async -> Result<Paginated<Bookmark>, BookmarksFailure>
}

class BookmarksDataStore: BookmarksDataStoreProtocol {
    static let shared: BookmarksDataStoreProtocol = BookmarksDataStore()
    
    private init() { }
    
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }
    
    func bookmark(tweetWithId tweetId: String) async -> Result<Void, BookmarkFailure> {
        let _: Void = await withUnsafeContinuation {
            continuation in
            
            DispatchQueue
                .global(qos: .background)
                .asyncAfter(deadline: .now()) {
                    continuation.resume(returning: Void())
                }
        }
        
        return .success(Void())
    }
    
    func unbookmark(tweetWithId tweetId: String) async -> Result<Void, UnbookmarkFailure> {
        let _: Void = await withUnsafeContinuation {
            continuation in
            
            DispatchQueue
                .global(qos: .background)
                .asyncAfter(deadline: .now()) {
                    continuation.resume(returning: Void())
                }
        }
        
        return .success(Void())
    }
    
    func bookmarks() async -> Result<Paginated<Bookmark>, BookmarksFailure> {
        return await paginatedBookmarks(after: nil)
    }
    
    func bookmarks(after nextToken: String) async -> Result<Paginated<Bookmark>, BookmarksFailure> {
        return await paginatedBookmarks(after: nextToken)
    }
    
    func paginatedBookmarks(after nextToken: String? = nil) async -> Result<Paginated<Bookmark>, BookmarksFailure> {
        let paginated = Paginated<Bookmark>(
            page: [],
            nextToken: nil
        )
        
        return .success(paginated)
    }
}
