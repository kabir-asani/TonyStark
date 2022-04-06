//
//  TxNetworkAssistant.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/03/22.
//

import Foundation

enum TxNetworkError: Error {
    case unknown
    case illegalStatusCode(statusCode: Int)
    case illegalData
}

protocol TxNetworkAssistantProtocol { }

class TxNetworkAssistant {
    typealias Networkable = Codable
    
    private let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
}

extension Dictionary where Key == String, Value == Codable {
    enum Stringify {
        case stringified(string: String)
        case empty
    }
    
    func stringify() -> Stringify {
        let parsed = self.compactMap { "\($0)=\($1)"}.joined(separator: "&")
        
        if parsed.isEmpty {
            let result: Stringify = .empty
            return result
        }
        
        let result: Stringify = .stringified(string: parsed)
        return result
    }
}
