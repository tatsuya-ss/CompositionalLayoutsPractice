//
//  CollectionViewTypeModel.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/08/24.
//

import Foundation

struct CollectionViewTypeModel {
    private var type = ["Grid",
                        "TwoColumn",
                        "DistinctSections",
                        "AdaptiveSections"]
    
    func returnNumberOfTypeCount() -> Int {
        type.count
    }
    
    func returnTypes() -> [String] {
        type
    }
    
}
