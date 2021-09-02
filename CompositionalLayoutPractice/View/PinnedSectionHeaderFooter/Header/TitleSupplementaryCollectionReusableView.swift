//
//  TitleSupplementaryCollectionReusableView.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/09/02.
//

import UIKit

final class TitleSupplementaryCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet private weak var label: UILabel!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    static let headerElementKind = ElementKind.sectionHeader
    static let footerElementKind = ElementKind.sectionFooter
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(title: String) {
        label.text = title
    }
    
}
