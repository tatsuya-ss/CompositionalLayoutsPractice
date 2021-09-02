//
//  DistinctSectionsViewController.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/08/25.
//

import UIKit

final class DistinctSectionsViewController: UIViewController {
    
    enum SectionLayoutKind: Int, CaseIterable {
        case list, grid5, grid3, grid2
        var columnCount: Int {
            switch self {
            case .list:
                return 1
            case .grid5:
                return 5
            case .grid3:
                return 3
            case .grid2:
                return 2
            }
        }
    }

    @IBOutlet private weak var distinctSectionsCollectionView: UICollectionView!
    
    private var numbers: [Int] = []
    private var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, Int>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (1...50).forEach { numbers.append($0) }
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        configureHierarchy()
        configureDataSource()
    }

}

extension DistinctSectionsViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex) else { return nil }
            let columns = sectionLayoutKind.columnCount
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupHeight = columns == 1 ?
            NSCollectionLayoutDimension.absolute(44) :
                NSCollectionLayoutDimension.fractionalWidth(0.2)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: columns)
            if sectionLayoutKind == .grid2 { group.interItemSpacing = .fixed(10) }
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            if sectionLayoutKind == .grid2 { section.interGroupSpacing = 10 }

            return section
        }
        
        return layout
    }
}

extension DistinctSectionsViewController {
    func configureHierarchy() {
        distinctSectionsCollectionView.collectionViewLayout = createLayout()
        distinctSectionsCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        distinctSectionsCollectionView.backgroundColor = .systemBackground
        distinctSectionsCollectionView.register(TextCollectionViewCell.nib, forCellWithReuseIdentifier: TextCollectionViewCell.identifier)
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
        
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, Int>(collectionView: distinctSectionsCollectionView, cellProvider: { collectionView, indexPath, identifier in
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
//            print("*******\($0), \($0.columnCount)の時*********")
//            print("$0.rawValue: \($0.rawValue)")
//            print("itemsPerSection: \(itemsPerSection)")
//            print("itemOffset: \(itemOffset)")
//            print("itemUpperbound: \(itemUpperbound)")
//            print("Array(itemOffset...itemUpperbound): \(Array(itemOffset...itemUpperbound))")
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
