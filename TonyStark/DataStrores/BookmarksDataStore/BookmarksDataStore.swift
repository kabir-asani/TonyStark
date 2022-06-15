//
//  BookmarksDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 27/04/22.
//

import Foundation

class BookmarksDataStore: DataStore {
    static let shared = BookmarksDataStore()
    
    private static let bookmarksURL = "\(BookmarksDataStore.baseUrl)/self/bookmarks"
    private static let createBookmarkURL = "\(BookmarksDataStore.bookmarksURL)"
    private static let deleteBookmarkURL = "\(BookmarksDataStore.bookmarksURL)/"
    
    private override init() { }
    
    func createBookmark(
        onTweetWithId tweetId: String
    ) async -> Result<Void, BookmarkFailure> {
        if let session = CurrentUserDataStore.shared.session {
            do {
                let bookmarkResult = try await TXNetworkAssistant.shared.post(
                    url: Self.createBookmarkURL,
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    ),
                    content: [
                        "tweetId": tweetId
                    ]
                )
                
                if bookmarkResult.statusCode == 204 {
                    TXEventBroker.shared.emit(
                        event: BookmarkCreatedEvent(
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
    
    func deleteBookmark(
        onTweetWithId tweetId: String
    ) async -> Result<Void, UnbookmarkFailure> {
        if let session = CurrentUserDataStore.shared.session {
            do {
                let removeBookmarkResult = try await TXNetworkAssistant.shared.delete(
                    url: Self.deleteBookmarkURL,
                    query: [
                        "tweetId": tweetId
                    ],
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    )
                )
                
                if removeBookmarkResult.statusCode == 204 {
                    TXEventBroker.shared.emit(
                        event: BookmarkDeletedEvent(
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
    
    func bookmarks(
        after nextToken: String? = nil
    ) async -> Result<Paginated<Bookmark>, BookmarksFailure> {
        if let session = CurrentUserDataStore.shared.session {
            do {
                let query = nextToken != nil ? [
                    "nextToken": nextToken!
                ] : nil
                
                let bookmarksResult = try await TXNetworkAssistant.shared.get(
                    url: Self.bookmarksURL,
                    query: query,
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    )
                )
                
                if bookmarksResult.statusCode == 200 {
                    let bookmarks = try TXJsonAssistant.decode(
                        SuccessData<Paginated<Bookmark>>.self,
                        from: bookmarksResult.data
                    ).data
                    
                    return .success(bookmarks)
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
