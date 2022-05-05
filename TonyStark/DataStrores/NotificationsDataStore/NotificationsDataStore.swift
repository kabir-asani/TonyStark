//
//  NotificationsDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 05/05/22.
//

import Foundation

protocol NotificationsDataStoreProtocol: DataStore {
    
}

class NotificationsDataStore: NotificationsDataStoreProtocol {
    static let shared: NotificationsDataStoreProtocol = NotificationsDataStore()
    
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }
}
