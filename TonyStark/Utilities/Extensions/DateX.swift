//
//  Date.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

extension Date {
    enum DateFormat: String {
        // E.g. 2 wk ago, 1 hr ago, 4 mo ago
        case visiblyPleasingShort
        
        // E.g. 12:30 PM • 12/12/2012
        case visiblyPleasingLong = "h:mm a • d/MM/yyyy"
    }
    
    static var current: Date {
        Date()
    }
    
    func formatted(as format: DateFormat) -> String {
        switch format {
        case .visiblyPleasingShort:
            let dateFormatter = RelativeDateTimeFormatter()
            dateFormatter.unitsStyle = .short
            let formattedDate = dateFormatter.localizedString(
                for: self,
                relativeTo: .current
            )
            
            return formattedDate
        case .visiblyPleasingLong:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format.rawValue
            
            let formattedDate = dateFormatter.string(
                from: self
            )
            
            return formattedDate
        }
    }
}
