//
//  TextCollectionViewCell.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/08/27.
//

import UIKit

final class TextCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var checkImageView: UIImageView!
    
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
