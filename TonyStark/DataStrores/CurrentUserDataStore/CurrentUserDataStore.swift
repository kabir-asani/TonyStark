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
    
    private static let sessionKey = "\(CurrentUserDataStore.self):Session"
    private static let userKey = "\(CurrentUserDataStore.self):User"
    
    private(set) var state: CurrentUserState = .absent
    
    private override init() { }
    
    override func bootUp() async {
        do {
            let sessionElement: TXLocalStorageElement<SessionDataTemplate> = try await TXLocalStorageAssistant.shallow.retrieve(key: Self.sessionKey)
            let userElement: TXLocalStorageElement<UserDataTemplate> = try await TXLocalStorageAssistant.shallow.retrieve(key: Self.userKey)
            
            let currentUser = CurrentUser(
                user: userElement.value.model(),
                session: sessionElement.value.model()
            )
            
            state = .present(currentUser)
        } catch {
            state = .absent
        }
    }
    
    func logIn(
        withDetails details: AuthenticationProfile,
        from provider: AuthenticationProvider
    ) async -> Result<Void, LogInFailure> {
        let _: Void = await withUnsafeContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                continuation.resume(returning: Void())
            }
        }
        
        return .failure(.unknown)
    }
    
    func logOut() async -> Result<Void, LogOutFailure> {
        return .failure(.unknown)
    }
    
    func edit(user: User) async -> Result<Void, EditUserFailure> {
        return .failure(.unknown)
    }
}
