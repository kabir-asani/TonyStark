//
//  Provider.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

protocol Provider {
    func bootUp() async
    
    func bootDown() async
}

class ProvidersRegistry {
    static let shared = ProvidersRegistry()
    
    private let providers: [Provider] = [
        UserProvider.current,
    ]
    
    func bootUp() async {
        for provider in providers {
            await provider.bootUp()
        }
    }
    
    func bootDown() async {
        for provider in providers {
            await provider.bootDown()
        }
    }
}
