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
    ) async -> Result<Tweet, CreateTweetFailure> {
        if let session = CurrentUserDataStore.shared.session {
            do {
                let tweetCreationResult = try await TXNetworkAssistant.shared.post(
                    url: Self.createTweetURL,
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    ),
                    content: [
                        "text": details.text.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )
                    ]
                )
                
                if tweetCreationResult.statusCode == 201 {
                    let tweet = try TXJsonAssistant.decode(
                        SuccessData<Tweet>.self,
                        from: tweetCreationResult.data
                    ).data
                    
                    TXEventBroker.shared.emit(
                        event: TweetCreatedEvent(
                            tweet: tweet
                        )
                    )
                    
                    return .success(tweet)
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
        if let session = CurrentUserDataStore.shared.session {
            do {
                let tweetDeletionResult = try await TXNetworkAssistant.shared.delete(
                    url: Self.deleteTweetURL(
                        withTweetId: tweetId
                    ),
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    )
                )
                
                if tweetDeletionResult.statusCode == 204 {
                    TXEventBroker.shared.emit(
                        event: TweetDeletedEvent(
                            id: tweetId
                        )
                    )
                    
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
   
    func tweets(
        ofUserWithId userId: String,
        after nextToken: String? = nil
    ) async -> Result<Paginated<Tweet>, TweetsFailure> {
        if let currentUser = CurrentUserDataStore.shared.user, let session = CurrentUserDataStore.shared.session {
            do {
                let query = nextToken != nil ? [
                    "nextToken": nextToken!
                ] : nil
                
                let tweetsResult = try await TXNetworkAssistant.shared.get(
                    url: currentUser.id == userId
                    ? Self.selfTweetsURL
                    : Self.otherUserTweetsURL(
                        withUserId: userId
                    ),
                    query: query,
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    )
                )
                
                if tweetsResult.statusCode == 200 {
                    let feed = try TXJsonAssistant.decode(
                        SuccessData<Paginated<Tweet>>.self,
                        from: tweetsResult.data
                    ).data
                    
                    return .success(feed)
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
}
