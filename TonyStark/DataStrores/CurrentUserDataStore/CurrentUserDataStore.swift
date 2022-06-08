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
        return .failure(.unknown)
    }
    
    func logOut() async -> Result<Void, LogOutFailure> {
        return .failure(.unknown)
    }
    
    func edit(user: User) async -> Result<Void, EditUserFailure> {
        return .failure(.unknown)
    }
}
//
//fileprivate class CurrentUserDataStoreCompanion: DataStoreCompanion {
//    func createToken(
//        withDetails details: AuthenticationProfile,
//        from provider: AuthenticationProvider
//    ) async throws -> Result<Session, CreateTokenFailure> {
//        do {
//            let tokenCreationResult = try await TXNetworkAssistant.shared.post(
//                url: baseURL + "/tokens",
//                headers: unsecureHeaders(),
//                content: [
//                    "credentials": [
//                        "token": details.accessToken,
//                        "provider": provider.rawValue
//                    ],
//                    "details": [
//                        "name": details.name,
//                        "email": details.email,
//                        "image": details.image
//                    ]
//                ]
//            )
//
//            if tokenCreationResult.statusCode == 201 {
//                let session = try TXJsonCoder.decode(
//                    SuccessDataTemplate<SessionDT>.self,
//                    from: tokenCreationResult.data
//                ).data
//
//                return .success(session.entity())
//            } else {
//                return .failure(.unknown)
//            }
//        } catch {
//            return .failure(.unknown)
//        }
//    }
//
//    func deleteToken() async throws -> Result<Void, DeleteTokenFailure> {
//        do {
//            let tokenDeletionResult = try await TXNetworkAssistant.shared.delete(
//                url: baseURL + "/tokens",
//                headers: secureHeaders(
//                    withAccessToken: CurrentUserDataStore.shared.session!.accessToken
//                )
//            )
//
//            if tokenDeletionResult.statusCode == 204 {
//                return .success(Void())
//            } else {
//                return .failure(.unknown)
//            }
//        } catch {
//            return .failure(.unknown)
//        }
//    }
//
//    func user() async throws -> Result<User, UserFailure> {
//        do {
//            let userResult = try await TXNetworkAssistant.shared.get(
//                url: baseURL + "/self",
//                headers: secureHeaders(
//                    withAccessToken: CurrentUserDataStore.shared.session!.accessToken
//                )
//            )
//
//            if userResult.statusCode == 200 {
//                let user = try TXJsonCoder.decode(
//                    SuccessDataTemplate<UserDT>.self,
//                    from: userResult.data
//                ).data
//
//                return .success(user.entity())
//            } else {
//                return .failure(.unknown)
//            }
//        } catch {
//            return .failure(.unknown)
//        }
//    }
//
//    func edit(
//        user updatedUser: User
//    ) async throws -> Result<User, EditUserFailure> {
//        do {
//            let editUserResult = try await TXNetworkAssistant.shared.patch(
//                url: baseURL + "/self",
//                headers: secureHeaders(
//                    withAccessToken: CurrentUserDataStore.shared.session!.accessToken
//                ),
//                content: [
//                    "username": updatedUser.username,
//                    "name": updatedUser.name,
//                    "description": updatedUser.description,
//                    "image": updatedUser.image
//                ]
//            )
//
//            if editUserResult.statusCode == 200 {
//
//            } else if editUserResult.statusCode == 409 {
//            } else {
//                return .failure(.unknown)
//            }
//        } catch {
//            throw EditUserFailure.unknown
//        }
//    }
//}
