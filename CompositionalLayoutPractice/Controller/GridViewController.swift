//
//  GridViewController.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/08/24.
//

import UIKit

final class GridViewController: UIViewController {
    @IBOutlet private weak var gridCollectionView: UICollectionView!
    private var numbers: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (0...100).forEach { numbers.append($0) }
        setupCollectionView()
    }

    private func setupCollectionView() {
        gridCollectionView.register(GridCollectionViewCell.nib,
                                    forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
        gridCollectionView.collectionViewLayout = createLayout()
        gridCollectionView.dataSource = self
    }
}

extension GridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gridCollectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as! GridCollectionViewCell
        cell.configure(number: numbers[indexPath.row])
        
        return cell
    }
    
    
}

extension GridViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    static func instantiate() -> GridViewController {
        let gridVC = UIStoryboard(name: "Grid", bundle: nil).instantiateInitialViewController() as! GridViewController
        return gridVC
    }
}
