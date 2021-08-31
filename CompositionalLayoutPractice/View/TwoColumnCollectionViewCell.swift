//
//  TwoColumnCollectionViewCell.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/08/25.
//

import UIKit

final class TwoColumnCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var numberLabel: UILabel!
    
    static let identifier = String(describing: TwoColumnCollectionViewCell.self)
    
    static let nib = UINib(nibName: String(describing: TwoColumnCollectionViewCell.self),
                           bundle: nil)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(number: Int) {
        let number = String(number)
        numberLabel.text = number
    }

}
