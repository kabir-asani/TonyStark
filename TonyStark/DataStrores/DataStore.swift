//
//  DataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

protocol DataStore {
    func bootUp() async
    
    func bootDown() async
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
