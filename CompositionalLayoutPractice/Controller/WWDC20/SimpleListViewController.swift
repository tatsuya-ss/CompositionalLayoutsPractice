//
//  SimpleListViewController.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/09/06.
//

import UIKit

final class SimpleListViewController: UIViewController {
    
    private enum Section: CaseIterable {
        case main
        case sub
    }

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var dataSource:
        UICollectionViewDiffableDataSource<Section, Int>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureDataSource()
        
    }
    
}

extension SimpleListViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
}

extension SimpleListViewController {
    
    private func configureHierarchy() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = "\(item)"
            content.image = UIImage(systemName: "star")
            if indexPath.section == 0 {
                content.imageProperties.tintColor = .purple
            } else {
                content.imageProperties.tintColor = .systemGreen
            }
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        var identifierOffset = 0
        let itemsPerSection = 50
        Section.allCases.forEach {
            snapshot.appendSections([$0])
            let maxItemIdentifier = identifierOffset + itemsPerSection
            snapshot.appendItems(Array(identifierOffset..<maxItemIdentifier))
            identifierOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }

}

extension SimpleListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
