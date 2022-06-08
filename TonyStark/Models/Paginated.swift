//
//  Paginate.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Paginated<T: Model>: Model {
    static var `default`: Paginated<T> {
        Paginated<T>(
            page: [],
            nextToken: nil
        )
    }
    
    let page: [T]
    let nextToken: String?
    
    func copyWith(
        page: [T]? = nil,
        nextToken: String? = nil
    ) -> Paginated<T> {
        Paginated(
            page: page ?? self.page,
            nextToken: nextToken ?? self.nextToken
        )
    }
}
