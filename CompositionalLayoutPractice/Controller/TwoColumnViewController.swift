//
//  TwoColumnViewController.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/08/25.
//

import UIKit

final class TwoColumnViewController: UIViewController {
    @IBOutlet private weak var twoColumnCollectionView: UICollectionView!
    private var numbers: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        (0...100).forEach { numbers.append($0) }
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        twoColumnCollectionView.register(TwoColumnCollectionViewCell.nib,
                                         forCellWithReuseIdentifier: TwoColumnCollectionViewCell.identifier)
        twoColumnCollectionView.dataSource = self
        twoColumnCollectionView.collectionViewLayout = createLayout()
    }

}

extension TwoColumnViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = twoColumnCollectionView.dequeueReusableCell(withReuseIdentifier: TwoColumnCollectionViewCell.identifier,
                                                               for: indexPath) as! TwoColumnCollectionViewCell
        cell.configure(number: numbers[indexPath.row])
        return cell
    }
    
}

extension TwoColumnViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    static func instantiate() -> TwoColumnViewController {
        let gridVC = UIStoryboard(name: "TwoColumn", bundle: nil).instantiateInitialViewController() as! TwoColumnViewController
        return gridVC
    }

}
