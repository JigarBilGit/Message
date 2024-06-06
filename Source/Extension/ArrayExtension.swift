//
//  IntExtension.swift
//  Billiyo Clinical
//
//  Created by Billiyo Health on 14/09/21.
//

import Foundation

extension Array where Element: Hashable {
    func duplicates() -> Array {
        let groups = Dictionary(grouping: self, by: {$0})
        let duplicateGroups = groups.filter {$1.count > 1}
        let duplicates = Array(duplicateGroups.keys)
        return duplicates
    }
}
