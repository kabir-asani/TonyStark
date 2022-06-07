//
//  NotificationsDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 05/05/22.
//

import Foundation

class NotificationsDataStore: DataStore {
    static let shared = NotificationsDataStore()
    
    private override init() { }
    
    func notifications(
        after nextToken: String? = nil
    ) async -> Result<Paginated<RemoteNotification>, RemoteNotificationsFailure> {
        return .failure(.unknown)
    }
}
