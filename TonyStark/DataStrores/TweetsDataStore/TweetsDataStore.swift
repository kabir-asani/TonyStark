//
//  TweetsDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 17/04/22.
//

import Foundation

class TweetsDataStore: DataStore {
    static let shared = TweetsDataStore()
    
    static let selfTweetsURL = "\(TweetsDataStore.baseUrl)/self/tweets"
    static let createTweetURL = "\(TweetsDataStore.baseUrl)/self/tweets"
    
    static func otherUserTweetsURL(
        withUserId userId: String
    ) -> String {
        "\(TweetsDataStore.baseUrl)/users/\(userId)/tweets"
    }
    static func deleteTweetURL(
        withTweetId tweetId: String
    ) -> String {
        "\(TweetsDataStore.baseUrl)/self/tweets/\(tweetId)"
    }
    
    private override init() { }
    
    func createTweet(
        withDetails details: ComposeDetails
    ) async -> Result<Void, CreateTweetFailure> {
        if let session = CurrentUserDataStore.shared.session {
            do {
                let tweetCreationResult = try await TXNetworkAssistant.shared.post(
                    url: Self.createTweetURL,
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    ),
                    content: [
                        "text": details.text
                    ]
                )
                
                if tweetCreationResult.statusCode == 201 {
                    return .success(Void())
                } else {
                    return .failure(.unknown)
                }
            } catch {
                return .failure(.unknown)
            }
        } else {
            return .failure(.unknown)
        }
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
