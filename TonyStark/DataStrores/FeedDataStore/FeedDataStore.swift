//
//  FeedDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 03/05/22.
//

import Foundation

class FeedDataStore: DataStore {
    static let shared = FeedDataStore()
    
    private static let feedURL = "\(FeedDataStore.baseUrl)/timeline"
    
    private override init() { }
    
    func feed(
        after nextToken: String? = nil
    ) async -> Result<Paginated<Tweet>, FeedFailure> {
        if let session = CurrentUserDataStore.shared.session {
            do {
                let feedResult = try await TXNetworkAssistant.shared.get(
                    url: Self.feedURL,
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    )
                )
                
                if feedResult.statusCode == 200 {
                    let feed = try TXJsonAssistant.decode(
                        SuccessData<Paginated<Tweet>>.self,
                        from: feedResult.data
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
