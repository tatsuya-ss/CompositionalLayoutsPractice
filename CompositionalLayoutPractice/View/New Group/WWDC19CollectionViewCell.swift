//
//  WWDC19CollectionViewCell.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/08/23.
//

import UIKit

class WWDC19CollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    
    static let identifier = String(describing: WWDC19CollectionViewCell.self)

    static let nib = UINib(nibName: String(describing: WWDC19CollectionViewCell.self), bundle: nil)
    
    func configure(title: String) {
        titleLabel.text = title
    }
    
    func numberConfigure(number: Int) {
        let number = String(number)
        titleLabel.text = number
    }
}
