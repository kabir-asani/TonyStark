//
//  OtherUserDataStore.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 17/06/22.
//

import Foundation

class OtherUserDataStore: DataStore {
    static let shared = OtherUserDataStore()
    
    static func otherUserURL(
        userId: String
    ) -> String {
        "\(OtherUserDataStore.baseUrl)/users/\(userId)"
    }
    
    func user(
        userId: String
    ) async -> Result<User, OtherUserFailure> {
        guard let currentSession = CurrentUserDataStore.shared.session else {
            return .failure(.unknown)
        }
        
        do {
            let userResult = try await TXNetworkAssistant.shared.get(
                url: Self.otherUserURL(
                    userId: userId
                ),
                headers: secureHeaders(
                    withAccessToken: currentSession.accessToken
                )
            )
            
            if userResult.statusCode == 200 {
                let user = try TXJsonAssistant.decode(
                    SuccessData<User>.self,
                    from: userResult.data
                ).data
                
                return .success(user)
            } else {
                return .failure(.unknown)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
