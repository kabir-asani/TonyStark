//
//  Date.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

extension Date {
    static func now() -> Date {
        return Date()
    }
    
    func formatted(
        format: String = "h:mm a • d/MM/yyyy"
    ) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = format
        
        let formattedDate = dateFormatter.string(from: self)
        
        return formattedDate
    }
}
