//
//  CurrentUserDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

struct CurrentUser {
    let user: User
    let session: Session
}

enum CurrentUserState {
    case present(CurrentUser)
    case absent
    
    func map<T>(
        onPresent: (CurrentUser) -> T,
        onAbsent: () -> T
    ) -> T {
        switch self {
        case .present(let currentUser):
            return onPresent(currentUser)
        case .absent:
            return onAbsent()
        }
    }
}


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
        } catch {
            user = nil
            session = nil
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
    
    func update(
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
}
