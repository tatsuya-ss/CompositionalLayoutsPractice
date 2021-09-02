//
//  SectionDecorationViewController.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/09/02.
//

import UIKit

final class SectionDecorationViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    private var currentSnapshot: NSDiffableDataSourceSnapshot<Int, Int>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureDataSource()
        
    }

}

extension SectionDecorationViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(elementKind: "section-background-element-kind")
        sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        section.decorationItems = [sectionBackgroundDecoration]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.register(SectionBackgroundDecorationView.self,
                        forDecorationViewOfKind: "section-background-element-kind")
        return layout
    }

}

extension SectionDecorationViewController {
    
    private func configureHierarchy() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(ListCollectionViewCell.nib,
                                forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
    }

    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier,
                                                          for: indexPath) as! ListCollectionViewCell
            cell.configure(number: "\(indexPath.section),\(indexPath.item), item: \(String(item))")
            return cell
        })
        
        let itemsPerSection = 5
        let sections = Array(0..<5)
        currentSnapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var itemOffset = 0
        sections.forEach {
            currentSnapshot.appendSections([$0])
            currentSnapshot.appendItems(Array(itemOffset..<itemOffset + itemsPerSection))
            itemOffset += itemsPerSection
        }
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
}

extension SectionDecorationViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
