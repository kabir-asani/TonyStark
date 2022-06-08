//
//  DataStore+Response.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 08/06/22.
//

import Foundation
protocol DataTemplate: Codable {
    associatedtype Entity
    
    init(from entity: Entity)
    
    func entity() -> Entity
}

struct SuccessDataTemplate<Data: Codable>: Codable {
    let data: Data
}

struct FailureDataTemplate<Reason: Codable>: Codable {
    let reason: Reason
}
