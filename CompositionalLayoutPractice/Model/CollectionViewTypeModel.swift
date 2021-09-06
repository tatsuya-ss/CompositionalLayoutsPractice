//
//  CollectionViewTypeModel.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/09/06.
//

import Foundation

struct CollectionViewTypeModel {
    private var type = ["Grid",
                        "TwoColumn",
                        "DistinctSections",
                        "AdaptiveSections",
                        "ItemBadges",
                        "PinnedSection",
                        "SectionDecoration",
                        "NestedGroups",
                        "OrthogonalScrollBehavior",
                        "SimpleList"]
    
    func returnNumberOfTypeCount() -> Int {
        type.count
    }
    
    func returnTypes() -> [String] {
        type
    }
    
}
