//
//  SectionBackgroundDecorationView.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/09/02.
//

import UIKit

final class SectionBackgroundDecorationView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
}

extension SectionBackgroundDecorationView {
    func configure() {
        backgroundColor = UIColor.systemGreen.withAlphaComponent(0.6)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12
    }
}
