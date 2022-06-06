//
//  CurrentUserDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

class CurrentUserDataStore: DataStore {
    static let shared = CurrentUserDataStore()
    
    var session: Session?
    var user: User?
    
    private init() { }
    
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }
    
    func logIn(
        with provider: AuthenticationProvider
    ) async -> Result<Void, LogInFailure> {
        return .success(Void())
    }
    
    func logOut() async -> Result<Void, LogOutFailure> {
        user = nil
        session = nil
        
        return .success(Void())
    }
    
    func edit(user: User) async -> Result<Void, EditUserFailure> {
        return .success(Void())
    }
}

