//
//  DataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

protocol DataStoreProtocol {
    func bootUp() async
    
    func bootDown() async
}

class DataStore {
    static let baseURL = ""
}

class DataStoresRegistry {
    static let shared = DataStoresRegistry()
    
    private let dataStores: [DataStoreProtocol] = [
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
