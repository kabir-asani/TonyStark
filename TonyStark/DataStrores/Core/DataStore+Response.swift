//
//  DataStore+Response.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 08/06/22.
//

import Foundation

struct SuccessData<Data: Model>: Codable {
    let data: Data
}

struct FailureData<Reason: Model>: Codable {
    let reason: Reason
}
