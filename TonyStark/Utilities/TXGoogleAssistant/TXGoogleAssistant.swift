//
//  TXGoogleAssistant.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 06/06/22.
//

import Foundation
import GoogleSignIn

enum GoogleAuthenticationFailure: Error {
    case unknown
}

class TXGoogleAssistant {
    static let shared = TXGoogleAssistant()
    
    private init() { }
    
    func authenticate(
        withPresenter viewController: UIViewController
    ) async -> Result<AuthenticationProfile, GoogleAuthenticationFailure> {
        let profile: AuthenticationProfile? = await withUnsafeContinuation {
            continuation in
            
            let configuration = GIDConfiguration(
                clientID: "736751499956-pd320ojrkl2poqug0k87979igarb3hvs.apps.googleusercontent.com"
            )
            
            GIDSignIn.sharedInstance.signIn(
                with: configuration,
                presenting: viewController
            ) { user, error in
                guard let user = user else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let profile = AuthenticationProfile(
                    accessToken: user.authentication.accessToken,
                    name: user.profile!.name,
                    email: user.profile!.email,
                    image: user.profile!.imageURL(withDimension: 512)!.absoluteString
                )
                
                continuation.resume(returning: profile)
            }
        }
        
        if let profile = profile {
            return .success(profile)
        } else {
            return .failure(.unknown)
        }
    }
}
