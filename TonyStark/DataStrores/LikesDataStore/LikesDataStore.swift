//
//  LikesDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 25/04/22.
//

import Foundation

protocol LikesDataStoreProtocol: DataStoreProtocol {
    func likes(onTweetWithId tweetId: String) async -> Result<Paginated<Like>, LikesFailure>
    
    func likes(
        onTweetWithId tweetId: String,
        after nextToken: String
    ) async -> Result<Paginated<Like>, LikesFailure>
    
    func like(tweetWithId tweetId: String) async -> Result<Void, LikeFailure>
    
    func unlike(tweetWithId tweetId: String) async -> Result<Void, UnlikeFailure>
}

class LikesDataStore: LikesDataStoreProtocol {
    static let shared: LikesDataStoreProtocol = LikesDataStore()
    
    private init() { }
    
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }

    func like(tweetWithId tweetId: String) async -> Result<Void, LikeFailure> {
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
    
    func unlike(tweetWithId tweetId: String) async -> Result<Void, UnlikeFailure> {
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
    
    func likes(onTweetWithId tweetId: String) async -> Result<Paginated<Like>, LikesFailure> {
        return await paginatedLikes(onTweetWithId: tweetId, after: nil)
    }
    
    func likes(
        onTweetWithId tweetId: String,
        after nextToken: String
    ) async -> Result<Paginated<Like>, LikesFailure> {
        return await paginatedLikes(onTweetWithId: tweetId, after: nextToken)
    }
    
    private func paginatedLikes(
        onTweetWithId tweetId: String,
        after nextToken: String?
    ) async -> Result<Paginated<Like>, LikesFailure> {
        let paginatedLikes = Paginated<Like>(
            page: [],
            nextToken: nil
        )
        
        return .success(paginatedLikes)
    }
}
