//
//  SearchArrayExtension.swift
//  RXassessment
//
//  Created by Moaaz Ahmed Fawzy Taha on 12/01/2022.
//

import Foundation

extension Array where Element: Hashable {
    
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
}
