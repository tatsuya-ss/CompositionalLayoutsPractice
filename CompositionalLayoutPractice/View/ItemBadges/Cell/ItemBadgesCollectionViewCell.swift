//
//  ItemBadgesCollectionViewCell.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/09/02.
//

import UIKit

final class ItemBadgesCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var numberLabel: UILabel!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(number: Int) {
        numberLabel.text = String(number)
    }

}
