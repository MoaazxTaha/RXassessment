//
//  StringExtension.swift
//  RXassessment
//
//  Created by Moaaz Ahmed Fawzy Taha on 12/01/2022.
//

import Foundation

extension String {
    
    var removingSpaces: String {
      return replacingOccurrences(of: " ", with: "")
    }
    
    
}
