//
//  CurrentUserDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

protocol CurrentUserDataStoreProtocol: DataStoreProtocol {
    var session: Session? { get }
    var user: User? { get }
    
    func logIn(with: AuthenticationProvider) async -> Result<Void, LogInFailure>
    
    func logOut() async -> Result<Void, LogOutFailure>
    
    func edit(user: User) async -> Result<Void, EditUserFailure>
}

class CurrentUserDataStore: DataStore, CurrentUserDataStoreProtocol {
    static let shared: CurrentUserDataStoreProtocol = CurrentUserDataStore()
    
    var session: Session?
    var user: User?
    
    private override init() { }
    
    func bootUp() async {
        // Do nothing
    }
    
    func bootDown() async {
        // Do nothing
    }
    
    func logIn(
        with provider: AuthenticationProvider
    ) async -> Result<Void, LogInFailure> {
        user = await withUnsafeContinuation {
            continuation in
            
            DispatchQueue
                .global(qos: .background)
                .asyncAfter(deadline: .now()) {
                    let user = User(
                        id: "mzaink",
                        name: "Zain Khan",
                        email: "zain@gmail.com",
                        username: "mzaink",
                        image: "https://pbs.twimg.com/profile_images/1483797876522512385/9CcO904A_400x400.jpg",
                        description: """
                        Hungry for knowledge. Satiated with life. :v:
                        """,
                        creationDate: .now(),
                        lastUpdatedDate: .now(),
                        socialDetails: User.SocialDetails(
                            followersCount: 0,
                            followeesCount: 0
                        ),
                        activityDetails: User.ActivityDetails(
                            tweetsCount: 0
                        ),
                        viewables: User.Viewables(following: true)
                    )
                    
                    continuation.resume(returning: user)
                }
        }
        
        session = Session(accessToken: "abracadabara")
        
        
        return .success(Void())
    }
    
    func logOut() async -> Result<Void, LogOutFailure> {
        let _: Void = await withUnsafeContinuation {
            continuation in
            
            DispatchQueue
                .global(qos: .background)
                .asyncAfter(
                    deadline: .now()
                ) {
                    continuation.resume(returning: Void())
                }
        }
        
        user = nil
        session = nil
        
        return .success(Void())
    }
    
    func edit(user: User) async -> Result<Void, EditUserFailure> {
        self.user = await withUnsafeContinuation {
            continuation in
            
            DispatchQueue
                .global(qos: .background)
                .asyncAfter(
                    deadline: .now()
                ) {
                    continuation.resume(returning: user)
                }
        }
        
        return .success(Void())
    }
}

