//
//  CommentsDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

class CommentsDataStore: DataStore {
    static let shared = CommentsDataStore()
    
    private init() { }
    
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }
    
    func createComment(
        withText text: String,
        onTweetWithId tweetId: String
    ) async -> Result<Void, CreateCommentFailure> {
        return .failure(.unknown)
    }
    
    func deleteComment(
        withId id: String
    ) async -> Result<Void, DeleteCommentFailure> {
        return .failure(.unknown)
    }
    
    func comments(
        ofTweetWithId tweetId: String,
        after nextToken: String? = nil
    ) async -> Result<Paginated<Comment>, CommentsFailure>{
        return .failure(.unknown)
    }
}
