//
//  GridCollectionViewCell.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/08/24.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static let identifier = String(describing: GridCollectionViewCell.self)
    
    static let nib = UINib(nibName: String(describing: GridCollectionViewCell.self), bundle: nil)

    func configure(number: Int) {
        let number = String(number)
        numberLabel.text = number
    }

}
