//
//  Paginate.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 13/04/22.
//

import Foundation

struct Paginated<T> {
    let page: [T]
    let nextToken: String?
    
    func copyWith(
        page: [T]? = nil,
        nextToken: String? = nil
    ) -> Paginated<T> {
        let newPaginated = Paginated(
            page: page ?? self.page,
            nextToken: nextToken ?? self.nextToken
        )
        
        return newPaginated
    }
}
