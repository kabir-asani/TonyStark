//
//  Date.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 20/04/22.
//

import Foundation

extension Date {
    enum DateFormat: String {
        // E.g. "2022-06-03T07:58:54Z"
        case utc = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        // E.g. 2 wk ago, 1 hr ago, 4 mo ago
        case visiblyPleasingShort
        
        // E.g. 12:30 PM • 12/12/2012
        case visiblyPleasingLong = "h:mm a • d/MM/yyyy"
    }
    
    static func now() -> Date {
        return Date()
    }
    
    static func parse(string dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = DateFormat.utc.rawValue
        let date = dateFormatter.date(from: dateString)
        
        return date ?? .now()
    }
    
    func formatted(as format: DateFormat) -> String {
        switch format {
        case .utc:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format.rawValue
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            let formattedDate = dateFormatter.string(from: self)
            
            return formattedDate
        case .visiblyPleasingShort:
            let dateFormatter = RelativeDateTimeFormatter()
            dateFormatter.unitsStyle = .short
            let formattedDate = dateFormatter.localizedString(for: self, relativeTo: .now())
            
            return formattedDate
        case .visiblyPleasingLong:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format.rawValue
            
            let formattedDate = dateFormatter.string(from: self)
            
            return formattedDate
        }
    }
}
