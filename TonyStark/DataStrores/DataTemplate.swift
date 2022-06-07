//
//  DataTemplate.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 04/06/22.
//

import Foundation

protocol DataTemplate: Codable {
    associatedtype Model
    
    func model() -> Model
}

struct SuccessDataTemplate<Data: Codable>: Codable {
    let data: Data
}

struct FailureDataTemplate<Reason: Codable>: Codable {
    let reason: Reason
}
