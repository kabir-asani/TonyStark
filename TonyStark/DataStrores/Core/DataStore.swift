//
//  DataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

class DataStore {
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }
}

class DataStoreCompanion {
    let baseURL = "https://nickfury14.herokuapp.com"
}

class DataStoresRegistry {
    static let shared = DataStoresRegistry()
    
    // TODO: Update baseURL to correct one
    
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
