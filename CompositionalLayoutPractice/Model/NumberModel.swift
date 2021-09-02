//
//  NumberModel.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/09/02.
//

import Foundation

final class NumberModel {
    private var numbers: [Int] = []

    init() {
        (0...100).forEach { numbers.append($0) }
    }
    
    func getNumbers() -> [Int] {
        numbers
    }
    
}
