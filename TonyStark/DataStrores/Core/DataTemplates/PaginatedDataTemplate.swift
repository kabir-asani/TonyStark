//
//  PaginatedDataTemplate.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 04/06/22.
//

import Foundation

let kMaximumPaginatedPageLength = 25

struct PaginatedDataTemplate<T: DataTemplate>: DataTemplate {
    let page: [T]
    let nextToken: String?
    
    enum PaginatedDataTemplate: String, CodingKey {
        case page
        case nextToken = "next_token"
    }
    
    func model() -> Paginated<T.Model> {
        let paginated = Paginated(
            page: page.map { $0.model() },
            nextToken: nextToken
        )
        
        return paginated
    }
}
