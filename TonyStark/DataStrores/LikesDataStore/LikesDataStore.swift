//
//  LikesDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 25/04/22.
//

import Foundation

class LikesDataStore: DataStore {
    static let shared = LikesDataStore()
    
    static func likesURL(
        tweetId: String
    ) -> String {
        "\(LikesDataStore.baseUrl)/self/tweets/\(tweetId)/likes"
    }
    
    static func createLikeURL(
        tweetId: String
    ) -> String {
        "\(LikesDataStore.baseUrl)/self/tweets/\(tweetId)/likes"
    }
    
    static func deleteLikeURL(
        tweetId: String
    ) -> String {
        "\(LikesDataStore.baseUrl)/self/tweets/\(tweetId)/likes"
    }
    
    private override init() { }

    func createLike(
        onTweetWithId tweetId: String
    ) async -> Result<Void, LikeFailure> {
        if let session = CurrentUserDataStore.shared.session {
            do {
                let likeCreationResult = try await TXNetworkAssistant.shared.post(
                    url: Self.createLikeURL(
                        tweetId: tweetId
                    ),
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    )
                )
                
                if likeCreationResult.statusCode == 204 {
                    TXEventBroker.shared.emit(
                        event: LikeCreatedEvent(
                            tweetId: tweetId
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
    
    func deleteLike(
        onTweetWithId tweetId: String
    ) async -> Result<Void, UnlikeFailure> {
        if let session = CurrentUserDataStore.shared.session {
            do {
                let likeCreationResult = try await TXNetworkAssistant.shared.delete(
                    url: Self.deleteLikeURL(
                        tweetId: tweetId
                    ),
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    )
                )
                
                if likeCreationResult.statusCode == 204 {
                    TXEventBroker.shared.emit(
                        event: LikeDeletedEvent(
                            tweetId: tweetId
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
    
    func likes(
        onTweetWithId tweetId: String,
        after nextToken: String? = nil
    ) async -> Result<Paginated<Like>, LikesFailure> {
        if let session = CurrentUserDataStore.shared.session {
            do {
                let query = nextToken != nil ? [
                    "nextToken": nextToken!
                ] : nil
                
                let likesResult = try await TXNetworkAssistant.shared.get(
                    url: Self.likesURL(
                        tweetId: tweetId
                    ),
                    query: query,
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    )
                )
                
                if likesResult.statusCode == 200 {
                    let likes = try TXJsonAssistant.decode(
                        SuccessData<Paginated<Like>>.self,
                        from: likesResult.data
                    ).data
                    
                    return .success(likes)
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
