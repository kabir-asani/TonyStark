//
//  TxNetworkAssistant.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/03/22.
//

import Foundation

typealias Networkable = Codable

enum TxNetworkError: Error {
    case illegalStatusCode(statusCode: Int)
}

protocol TxNetworkAssistantProtocol {
    func get<T: Networkable>(
        url: String,
        completion: @escaping (Result<T, TxNetworkError>) -> Void
    )
    
    func get<T: Networkable>(
        url baseUrl: String,
        withQueryParameters queryParameters: [String: Any],
        completion: @escaping (Result<T, TxNetworkError>) -> Void
    )
}

class TxNetworkAssistant: TxNetworkAssistantProtocol {
    static let shared: TxNetworkAssistantProtocol = TxNetworkAssistant()
    
    func get<T: Networkable>(
        url: String,
        completion: @escaping (Result<T, TxNetworkError>) -> Void
    ) {
    }
    
    func get<T: Networkable>(
        url baseUrl: String,
        withQueryParameters queryParameters: [String: Any],
        completion: @escaping (Result<T, TxNetworkError>) -> Void
    ) {
    }
}
