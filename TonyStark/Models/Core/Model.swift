//
//  Model.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 08/06/22.
//

import Foundation

protocol Model: Codable {
    associatedtype Implementer
    
    static var `default`: Implementer { get }
}
