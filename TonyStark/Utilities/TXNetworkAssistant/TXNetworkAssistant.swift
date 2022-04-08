//
//  TxNetworkAssistant.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/03/22.
//

import Foundation

enum TXNetworkFailure: Error {
    case unknown
    case malformedURL
    case malformedContent
}

struct TXNetworkSuccess {
    let data: Data
    let statusCode: Int
}

protocol TXNetworkAssistantProtocol {
    func get(
        url: String,
        query: [String: String]?,
        headers: [String: String]?,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    )
    
    func post(
        url: String,
        headers: [String: String]?,
        query: [String: String]?,
        content: Encodable,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    )
    
    func put(
        url: String,
        headers: [String: String]?,
        query: [String: String]?,
        content: Encodable,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    )
    
    func patch(
        url: String,
        headers: [String: String]?,
        query: [String: String]?,
        content: Encodable,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    )
    
    func delete(
        url: String,
        headers: [String: String]?,
        query: [String: String]?,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    )
}

class TXNetworkAssistant: TXNetworkAssistantProtocol {
    static let shared: TXNetworkAssistantProtocol = TXNetworkAssistant()
    
    private init() { }
    
    func get(
        url baseURL: String,
        query: [String: String]?,
        headers: [String: String]?,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    ) {
        request(
            url: baseURL,
            method: "GET",
            headers: headers,
            query: query,
            content: nil,
            completion: completion
        )
    }
    
    func post(
        url baseURL: String,
        headers: [String: String]?,
        query: [String: String]?,
        content: Encodable,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    ) {
        request(
            url: baseURL,
            method: "POST",
            headers: headers,
            query: query,
            content: content,
            completion: completion
        )
    }
    
    func put(
        url baseURL: String,
        headers: [String: String]?,
        query: [String: String]?,
        content: Encodable,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    ) {
        request(
            url: baseURL,
            method: "PUT",
            headers: headers,
            query: query,
            content: content,
            completion: completion
        )
    }
    
    func patch(
        url baseURL: String,
        headers: [String: String]?,
        query: [String: String]?,
        content: Encodable,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    ) {
        request(
            url: baseURL,
            method: "PATCH",
            headers: headers,
            query: query,
            content: content,
            completion: completion
        )
    }
    
    func delete(
        url baseURL: String,
        headers: [String: String]?,
        query: [String: String]?,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    ) {
        request(
            url: baseURL,
            method: "DELETE",
            headers: headers,
            query: query,
            content: nil,
            completion: completion
        )
    }
    
    private func request(
        url baseURL: String,
        method: String,
        headers: [String: String]?,
        query: [String: String]?,
        content: Encodable?,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    ) {
        guard let url = URL(string: baseURL.buildCompleteURL(query: query)) else {
            completion(.failure(.malformedURL))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.setMethod(method)
        
        if let headers = headers {
            request.setHeaders(headers)
        }
        
        if let content = content {
            do {
                try request.setContent(content)
            } catch {
                completion(.failure(.malformedContent))
                return
            }
        }
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }
            
            let result = TXNetworkSuccess(
                data: data,
                statusCode: response.statusCode
            )
            
            completion(.success(result))
        }
    }
}


extension URLRequest {
    mutating func setMethod(_ method: String) {
        self.httpMethod = method
    }
    
    mutating func setHeaders(_ headers: [String: String]) {
        for (key, value) in headers {
            self.setValue(
                value,
                forHTTPHeaderField: key
            )
        }
    }
    
    mutating func setContent(_ content: Encodable) throws {
        self.httpBody = try JSONSerialization.data(withJSONObject: content, options: .prettyPrinted)
    }
}

extension String {
    func buildCompleteURL(query: [String: String]?) -> String {
        var url = self
        
        if let query = query, !query.isEmpty {
            let stringifiedQuery = query.compactMap { "\($0)=\($1)" }.joined(separator: "&")
            
            url += ("?" + stringifiedQuery)
        }
        
        return url
    }
}
