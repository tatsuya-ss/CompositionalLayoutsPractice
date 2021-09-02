//
//  AdaptiveSectionsViewController.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/08/31.
//

import UIKit

final class AdaptiveSectionsViewController: UIViewController {
    
    
    enum SectionLayoutKind: Int, CaseIterable {
        case list, grid5, grid3, grid2
        func columnCount(for width: CGFloat) -> Int {
            let wideMode = width > 800
            switch self {
            case .grid3:
                return wideMode ? 6 : 3
            case .grid5:
                return wideMode ? 10 : 5
            case .list:
                return wideMode ? 2 : 1
            case .grid2:
                return wideMode ? 4 : 2
            }
        }
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, Int>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
    
}

extension AdaptiveSectionsViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let layoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }
            
            let columns = layoutKind.columnCount(for: layoutEnvironment.container.effectiveContentSize.width)
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2 , trailing: 2)
            
            let groupHeight = layoutKind == .list ?
                NSCollectionLayoutDimension.absolute(44) :
                NSCollectionLayoutDimension.fractionalWidth(0.2)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: columns)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        return layout
    }
}

extension AdaptiveSectionsViewController {
    func configureHierarchy() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(TextCollectionViewCell.nib,
                                forCellWithReuseIdentifier: TextCollectionViewCell.identifier)
    }
    
    func configureDataSource() {
        let listCellRegistration = UICollectionView.CellRegistration<ListCell, Int> { (cell, indexPath, identifier) in
            cell.label.text = "\(identifier)"
            cell.backgroundColor = .systemPink
        }
        
        let textCellRegistration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            cell.label.text = "\(identifier)"
            cell.contentView.backgroundColor = .systemYellow
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = cell.bounds.width / 2
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        let textCellGrid3Registration = UICollectionView.CellRegistration<TextCell, Int> { (cell, indexPath, identifier) in
            cell.label.text = "\(identifier)"
            cell.contentView.backgroundColor = .systemOrange
            cell.contentView.layer.borderColor = UIColor.black.cgColor
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.cornerRadius = 20
            cell.label.textAlignment = .center
            cell.label.font = UIFont.preferredFont(forTextStyle: .title1)
        }
        
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, Int>(collectionView: collectionView, cellProvider: { collectionView, indexPath, identifier in
            switch SectionLayoutKind(rawValue: indexPath.section)! {
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration,
                                                                    for: indexPath,
                                                                    item: identifier)
            case .grid5:
                return collectionView.dequeueConfiguredReusableCell(using: textCellRegistration,
                                                                    for: indexPath,
                                                                    item: identifier)
            case .grid3:
                return collectionView.dequeueConfiguredReusableCell(using: textCellGrid3Registration,
                                                                    for: indexPath,
                                                                    item: identifier)
            case .grid2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionViewCell.identifier, for: indexPath) as! TextCollectionViewCell
                cell.backgroundColor = .systemPink
                cell.configure(number: identifier)
                cell.layer.cornerRadius = 10
                return cell
            }
        })
        
        let itemsPerSection = 10
        var snapshot = NSDiffableDataSourceSnapshot<SectionLayoutKind, Int>()
        SectionLayoutKind.allCases.forEach {
            snapshot.appendSections([$0])
            let itemOffset = $0.rawValue * itemsPerSection
            let itemUpperbound = itemOffset + itemsPerSection
            snapshot.appendItems(Array(itemOffset...itemUpperbound))
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}
