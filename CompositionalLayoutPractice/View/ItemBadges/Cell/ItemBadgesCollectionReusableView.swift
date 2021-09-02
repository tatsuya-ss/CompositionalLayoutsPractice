//
//  ItemBadgesCollectionReusableView.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/09/02.
//

import UIKit

final class ItemBadgesCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet private weak var badgeImageView: UIImageView!
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure() {
        badgeImageView.image = UIImage(named: "checkmark.seal.fill")
    }
    
}
