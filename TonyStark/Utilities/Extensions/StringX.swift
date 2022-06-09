//
//  StringX.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 02/05/22.
//

import Foundation

extension String {
    func count(
        ofCharacter keyCharacter: Character
    ) -> Int {
        var count = 0
        
        for character in self {
            if character == keyCharacter {
                count += 1
            }
        }
        
        return count
    }
}
