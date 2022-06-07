//
//  Requests.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 03/05/22.
//

import Foundation

enum AuthenticationProvider: String {
    case google = "google"
    case apple = "apple"
}

struct AuthenticationProfile {
    let accessToken: String
    let name: String
    let email: String
    let image: String
}
