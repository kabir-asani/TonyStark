//
//  TxNetworkAssistant.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 23/03/22.
//

import Foundation



class TXNetworkAssistant {
    enum TXNetworkFailure: Error {
        case unknown
        case malformedURL
        case malformedContent
    }
    
    typealias TXNetworkSuccess = (
        data: Data,
        statusCode: Int
    )
    
    private let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func get(
        path: String,
        query: [String: String]?,
        headers: [String: String]?,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    ) {
        request(
            path: path,
            method: "GET",
            headers: headers,
            query: query,
            content: nil,
            completion: completion
        )
    }
    
    func post(
        path: String,
        headers: [String: String]?,
        query: [String: Codable]?,
        content: Encodable,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    ) {
        request(
            path: path,
            method: "POST",
            headers: headers,
            query: query,
            content: content,
            completion: completion
        )
    }
    
    func put(
        path: String,
        headers: [String: String]?,
        query: [String: Codable]?,
        content: Encodable,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    ) {
        request(
            path: path,
            method: "PUT",
            headers: headers,
            query: query,
            content: content,
            completion: completion
        )
    }
    
    func patch(
        path: String,
        headers: [String: String]?,
        query: [String: Codable]?,
        content: Encodable,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    ) {
        request(
            path: path,
            method: "PATCH",
            headers: headers,
            query: query,
            content: content,
            completion: completion
        )
    }
    
    func delete(
        path: String,
        headers: [String: String]?,
        query: [String: Codable]?,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    ) {
        request(
            path: path,
            method: "DELETE",
            headers: headers,
            query: query,
            content: nil,
            completion: completion
        )
    }
    
    func request(
        path: String,
        method: String,
        headers: [String: String]?,
        query: [String: Encodable]?,
        content: Encodable?,
        completion: @escaping (Result<TXNetworkSuccess, TXNetworkFailure>) -> Void
    ) {
        guard let url = URL(string: buildCompleteURL(withPath: path, query: query)) else {
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
        
        let task = URLSession.shared.dataTask(with: request) {
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
            
            completion(.success((data: data, statusCode: response.statusCode)))
        }
        
        task.resume()
    }
    
    private func buildCompleteURL(
        withPath path: String,
        query: [String: Encodable]?
    ) -> String {
        var url = baseUrl.hasSuffix("/") ? baseUrl + path : baseUrl + "/" + path
        
        if let query = query, !query.isEmpty {
            let stringifiedQuery = query.compactMap { "\($0)=\($1)" }.joined(separator: "&")
            
            url += ("?" + stringifiedQuery)
        }
        
        return url
    }
}

extension URLRequest {
    mutating func setMethod(_ method: String) {
        self.httpMethod = method
    }
    
    mutating func setHeaders(_ headers: [String: String]) {
        for (key, value) in headers {
            self.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    mutating func setContent(_ content: Encodable) throws {
        self.httpBody = try JSONSerialization.data(
            withJSONObject: content,
            options: .prettyPrinted
        )
    }
}
