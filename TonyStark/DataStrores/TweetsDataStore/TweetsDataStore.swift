//
//  TweetsDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 17/04/22.
//

import Foundation

class TweetsDataStore: DataStore {
    static let shared = TweetsDataStore()
    
    private override init() { }
    
    func createTweet(
        withDetails details: ComposeDetails
    ) async -> Result<Tweet, CreateTweetFailure> {
        return .failure(.unknown)
    }
    
    func deleteTweet(
        withId tweetId: String
    ) async -> Result<Void, CreateTweetFailure> {
        return .success(Void())
    }
   
    func tweets(
        ofUserWithId userId: String,
        after nextToken: String? = nil
    ) async -> Result<Paginated<Tweet>, TweetsFailure> {
        return .failure(.unknown)
    }
}
