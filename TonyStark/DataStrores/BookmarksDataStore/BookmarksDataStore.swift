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
    private static let bookmarkURL = "\(BookmarksDataStore.bookmarksURL)"
    private static func unbookmarkURL(
        bookmarkId: String
    ) -> String{
        "\(BookmarksDataStore.bookmarksURL)/\(bookmarkId)"
    }
    
    private override init() { }
    
    func createBookmark(
        forTweetWithId tweetId: String
    ) async -> Result<Bookmark, BookmarkFailure> {
        if let session = CurrentUserDataStore.shared.session {
            do {
                let bookmarkResult = try await TXNetworkAssistant.shared.post(
                    url: Self.bookmarkURL,
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    ),
                    content: [
                        "tweetId": tweetId
                    ]
                )
                
                if bookmarkResult.statusCode == 201 {
                    let bookmark = try TXJsonAssistant.decode(
                        SuccessData<Bookmark>.self,
                        from: bookmarkResult.data
                    ).data
                    
                    TXEventBroker.shared.emit(
                        event: CreateBookmarkEvent(
                            bookmark: bookmark
                        )
                    )
                    
                    return .success(bookmark)
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
    
    func removeBookmark(
        withId bookmarkId: String,
        andWithTweetId tweetId: String
    ) async -> Result<Void, UnbookmarkFailure> {
        if let session = CurrentUserDataStore.shared.session {
            do {
                let removeBookmarkResult = try await TXNetworkAssistant.shared.delete(
                    url: Self.unbookmarkURL(
                        bookmarkId: bookmarkId
                    ),
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    )
                )
                
                if removeBookmarkResult.statusCode == 204 {
                    TXEventBroker.shared.emit(
                        event: DeleteBookmarkEvent(
                            bookmarkId: bookmarkId,
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
        return .failure(.unknown)
    }
}
