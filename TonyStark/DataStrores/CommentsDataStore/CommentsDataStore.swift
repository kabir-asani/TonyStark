//
//  CommentsDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

class CommentsDataStore: DataStore {
    static let shared = CommentsDataStore()
    
    static func commentsURL(
        tweetId: String
    ) -> String {
        "\(CommentsDataStore.baseUrl)/self/tweets/\(tweetId)/comments"
    }
    
    static func createCommentURL(
        tweetId: String
    ) -> String {
        "\(CommentsDataStore.baseUrl)/self/tweets/\(tweetId)/comments"
    }
    
    static func deleteCommentURL(
        tweetId: String
    ) -> String {
        "\(CommentsDataStore.baseUrl)/self/tweets/\(tweetId)/comments"
    }
    
    private override init() { }
    
    func createComment(
        withText text: String,
        onTweetWithId tweetId: String
    ) async -> Result<Void, CreateCommentFailure> {
        if let session = CurrentUserDataStore.shared.session {
            do {
                let likeCreationResult = try await TXNetworkAssistant.shared.post(
                    url: Self.createCommentURL(
                        tweetId: tweetId
                    ),
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    ),
                    content: [
                        "text": text
                    ]
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
    
    func deleteComment(
        withId id: String,
        onTweetWithId tweet: String
    ) async -> Result<Void, DeleteCommentFailure> {
        return .failure(.unknown)
    }
    
    func comments(
        onTweetWithId tweetId: String,
        after nextToken: String? = nil
    ) async -> Result<Paginated<Comment>, CommentsFailure>{
        guard let session = CurrentUserDataStore.shared.session else {
            return .failure(.unknown)
        }
        
        do {
            let query = nextToken != nil ? [
                "nextToken": nextToken!
            ] : nil
            
            let commentsResult = try await TXNetworkAssistant.shared.get(
                url: Self.commentsURL(
                    tweetId: tweetId
                ),
                query: query,
                headers: secureHeaders(
                    withAccessToken: session.accessToken
                )
            )
            
            if commentsResult.statusCode == 200 {
                let comments = try TXJsonAssistant.decode(
                    SuccessData<Paginated<Comment>>.self,
                    from: commentsResult.data
                ).data
                
                return .success(comments)
            } else {
                return .failure(.unknown)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
