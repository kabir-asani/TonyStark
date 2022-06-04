//
//  NotificationsDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 05/05/22.
//

import Foundation

protocol NotificationsDataStoreProtocol: DataStoreProtocol {
    func notifications() async -> Result<Paginated<RemoteNotification>, RemoteNotificationsFailure>
}

class NotificationsDataStore: NotificationsDataStoreProtocol {
    static let shared: NotificationsDataStoreProtocol = NotificationsDataStore()
    
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }
    
    func notifications() async -> Result<Paginated<RemoteNotification>, RemoteNotificationsFailure> {
        let _: Void = await withUnsafeContinuation {
            continuation in
            
            DispatchQueue
                .global(qos: .background)
                .asyncAfter(deadline: .now()) {
                    continuation.resume(returning: Void())
                }
        }
        
        return .success(.default())
    }
}
