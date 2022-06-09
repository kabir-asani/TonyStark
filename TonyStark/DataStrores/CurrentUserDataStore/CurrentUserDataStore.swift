//
//  CurrentUserDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

class CurrentUserDataStore: DataStore {
    static let shared = CurrentUserDataStore()
    
    private static let sessionKey = "\(CurrentUserDataStore.self):\(Session.self)"
    private static let userKey = "\(CurrentUserDataStore.self):\(User.self)"
    
    private static let tokensURL = "\(CurrentUserDataStore.baseUrl)/tokens"
    private static let selfURL = "\(CurrentUserDataStore.baseUrl)/self"
    
    private(set) var user: User?
    private(set) var session: Session?
    
    private override init() { }
    
    override func bootUp() async {
        do {
            let storedSession: TXLocalStorageElement<Session> = try await TXLocalStorageAssistant.shallow.retrieve(
                key: Self.sessionKey
            )
            let storedUser: TXLocalStorageElement<User> = try await TXLocalStorageAssistant.shallow.retrieve(
                key: Self.userKey
            )
            
            self.user = storedUser.value
            self.session = storedSession.value
            
            TXEventBroker.shared.emit(
                event: LogInEvent()
            )
        } catch {
            user = nil
            session = nil
            
            TXEventBroker.shared.emit(
                event: LogOutEvent()
            )
        }
        
        TXEventBroker.shared.listen {
            [weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            if event is TweetCreatedEvent {
                strongSelf.onTweetCreated()
            }
            
            if event is TweetDeletedEvent {
                strongSelf.onTweetDeleted()
            }
        }
    }
    
    func logIn(
        withDetails details: AuthenticationProfile,
        from provider: AuthenticationProvider
    ) async -> Result<Void, LogInFailure> {
        do {
            let tokenCreationResult = try await TXNetworkAssistant.shared.post(
                url: Self.tokensURL,
                headers: unsecureHeaders(),
                content: [
                    "credentials": [
                        "token": details.accessToken,
                        "provider": provider.rawValue
                    ],
                    "details": [
                        "name": details.name,
                        "email": details.email,
                        "image": details.image
                    ]
                ]
            )
            
            if tokenCreationResult.statusCode == 201 {
                let session = try TXJsonAssistant.decode(
                    SuccessData<Session>.self,
                    from: tokenCreationResult.data
                ).data
                
                let currentUserResult = try await TXNetworkAssistant.shared.get(
                    url: Self.selfURL,
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    )
                )
                
                if currentUserResult.statusCode == 200 {
                    let user = try TXJsonAssistant.decode(
                        SuccessData<User>.self,
                        from: currentUserResult.data
                    ).data
                    
                    try await TXLocalStorageAssistant.shallow.store(
                        key: Self.sessionKey,
                        value: session
                    )
                    try await TXLocalStorageAssistant.shallow.store(
                        key: Self.userKey,
                        value: user
                    )
                    
                    TXEventBroker.shared.emit(
                        event: LogInEvent()
                    )
                    
                    self.session = session
                    self.user = user
                    
                    return .success(Void())
                } else {
                    return .failure(.unknown)
                }
            } else {
                return .failure(.unknown)
            }
        } catch {
            return .failure(.unknown)
        }
    }
    
    func logOut() async -> Result<Void, LogOutFailure> {
        if let session = session {
            do {
                let tokenDeletionResult = try await TXNetworkAssistant.shared.delete(
                    url: Self.tokensURL,
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    )
                )
                
                if tokenDeletionResult.statusCode == 204 {
                    self.session = nil
                    self.user = nil
                    
                    try await TXLocalStorageAssistant.shallow.delete(
                        key: Self.sessionKey
                    )
                    try await TXLocalStorageAssistant.shallow.delete(
                        key: Self.userKey
                    )
                    
                    TXEventBroker.shared.emit(
                        event: LogOutEvent()
                    )
                    
                    return .success(Void())
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
    
    
    func refreshUser() async -> Result<Void, RefreshUserFailure> {
        if let session = session {
            do {
                let currentUserResult = try await TXNetworkAssistant.shared.get(
                    url: Self.selfURL,
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    )
                )
                
                if currentUserResult.statusCode == 200 {
                    let user = try TXJsonAssistant.decode(
                        SuccessData<User>.self,
                        from: currentUserResult.data
                    ).data
                    
                    try await TXLocalStorageAssistant.shallow.update(
                        key: Self.userKey,
                        value: user
                    )
                    
                    self.user = user
                    
                    return .success(Void())
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
    
    func updateUser(
        to updatedUser: User
    ) async -> Result<Void, UpdateUserFailure> {
        if let session = session {
            do {
                let updateUserResult = try await TXNetworkAssistant.shared.patch(
                    url: Self.selfURL,
                    headers: secureHeaders(
                        withAccessToken: session.accessToken
                    ),
                    content: [
                        "username": updatedUser.username,
                        "name": updatedUser.name,
                        "description": updatedUser.description,
                        "image": updatedUser.image
                    ]
                )
                
                if updateUserResult.statusCode == 200 {
                    let user = try TXJsonAssistant.decode(
                        SuccessData<User>.self,
                        from: updateUserResult.data
                    ).data
                    
                    try await TXLocalStorageAssistant.shallow.update(
                        key: Self.userKey,
                        value: user
                    )
                    
                    self.user = user
                    
                    return .success(Void())
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
    
    private func onTweetCreated() {
        if let user = self.user {
            let updatedUser = user.copyWith(
                activityDetails: user.activityDetails.copyWith(
                    tweetsCount: user.activityDetails.tweetsCount + 1
                )
            )
            
            self.user = updatedUser
            
            Task {
                do {
                    try await TXLocalStorageAssistant.shallow.update(
                        key: Self.userKey,
                        value: updatedUser
                    )
                } catch {
                    // Do nothing
                }
            }
        }
    }
    
    private func onTweetDeleted() {
        if let user = self.user {
            let updatedUser = user.copyWith(
                activityDetails: user.activityDetails.copyWith(
                    tweetsCount: user.activityDetails.tweetsCount - 1
                )
            )
            
            self.user = updatedUser
            
            Task {
                do {
                    try await TXLocalStorageAssistant.shallow.update(
                        key: Self.userKey,
                        value: updatedUser
                    )
                } catch {
                    // Do nothing
                }
            }
        }
    }
}
