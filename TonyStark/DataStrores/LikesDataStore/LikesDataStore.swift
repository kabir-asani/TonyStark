//
//  LikesDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 25/04/22.
//

import Foundation

class LikesDataStore: DataStore {
    static let shared = LikesDataStore()
    
    private override init() { }

    func like(
        teetWithId tweetId: String
    ) async -> Result<Void, LikeFailure> {
        return .failure(.unknown)
    }
    
    func unlike(
        tweetWithId tweetId: String
    ) async -> Result<Void, UnlikeFailure> {
        return .failure(.unknown)
    }
    
    func likes(
        onTweetWithId tweetId: String,
        after nextToken: String? = nil
    ) async -> Result<Paginated<Like>, LikesFailure> {
        return .failure(.unknown)
    }
}
