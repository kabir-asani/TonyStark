//
//  SessionDataTemplate.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 04/06/22.
//

import Foundation

struct SessionDataTemplate: DataTemplate {
    let accessToken: String
    
    enum SessionDataTemplateKeys: String, CodingKey {
        case accessToken = "access_token"
    }
    
    func model() -> Session {
        let session = Session(
            accessToken: accessToken
        )
        
        return session
    }
}
