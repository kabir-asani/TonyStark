//
//  DateFormatterX.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 08/06/22.
//

import Foundation

extension DateFormatter {
    static var utc: DateFormatter {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            dateFormatter.locale = Locale(
                identifier: "en_US"
            )
            dateFormatter.timeZone = TimeZone(
                secondsFromGMT: 0
            )
            
            return dateFormatter
        }
    }
}
