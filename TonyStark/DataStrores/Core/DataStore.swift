//
//  DataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

class DataStore {
    static let baseUrl = "https://nickfury14.herokuapp.com"
    
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }
    
    
    func unsecureHeaders() -> [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    func secureHeaders(withAccessToken accessToken: String) -> [String: String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
    }
}

class DataStoresRegistry {
    static let shared = DataStoresRegistry()
    
    private let dataStores: [DataStore] = [
        CurrentUserDataStore.shared,
        FeedDataStore.shared,
        TweetsDataStore.shared,
        CommentsDataStore.shared,
        LikesDataStore.shared,
        SearchDataStore.shared,
        SocialsDataStore.shared,
        BookmarksDataStore.shared,
        NotificationsDataStore.shared
    ]
    
    func bootUp() async {
        for dataStore in dataStores {
            await dataStore.bootUp()
        }
    }
    
    func bootDown() async {
        for dataStore in dataStores {
            await dataStore.bootDown()
        }
    }
}
