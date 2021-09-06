//
//  PinnedSectionHeaderFooterViewController.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/09/02.
//

import UIKit

struct ElementKind {
    static let badge = "badge-element-kind"
    static let background = "background-element-kind"
    static let sectionHeader = "section-header-element-kind"
    static let sectionFooter = "section-footer-element-kind"
    static let layoutHeader = "layout-header-element-kind"
    static let layoutFooter = "layout-footer-element-kind"
}

final class PinnedSectionHeaderFooterViewController: UIViewController {
    
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureDataSource()
        
    }
    
    
}

extension PinnedSectionHeaderFooterViewController {
    
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(60)),
            elementKind: ElementKind.sectionHeader,
            alignment: .top)
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(60)),
            elementKind: ElementKind.sectionFooter,
            alignment: .bottom)
        sectionHeader.pinToVisibleBounds = true
        sectionHeader.zIndex = 2
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

extension PinnedSectionHeaderFooterViewController {
    
    private func configureHierarchy() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(ListCollectionViewCell.nib,
                                forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
        collectionView.register(TitleSupplementaryCollectionReusableView.nib,
                                forSupplementaryViewOfKind: ElementKind.sectionHeader,
                                withReuseIdentifier: TitleSupplementaryCollectionReusableView.identifier)
        collectionView.register(TitleSupplementaryCollectionReusableView.nib,
                                forSupplementaryViewOfKind: ElementKind.sectionFooter,
                                withReuseIdentifier: TitleSupplementaryCollectionReusableView.identifier)
    }
    
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath
            ) as! ListCollectionViewCell
            cell.configure(number: "\(indexPath.section),\(indexPath.item)")
            return cell
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryCollectionReusableView>(elementKind: TitleSupplementaryCollectionReusableView.headerElementKind) {
            (supplementaryView, string, indexPath) in
            let header = self.collectionView.dequeueReusableSupplementaryView(ofKind: TitleSupplementaryCollectionReusableView.headerElementKind,
                                                                              withReuseIdentifier: TitleSupplementaryCollectionReusableView.identifier,
                                                                              for: indexPath) as! TitleSupplementaryCollectionReusableView
            
            header.configure(title: "\(string) for section \(indexPath.section)")
            header.backgroundColor = .lightGray
            header.layer.borderColor = UIColor.black.cgColor
            header.layer.borderWidth = 1.0
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration
        <TitleSupplementaryCollectionReusableView>(elementKind: TitleSupplementaryCollectionReusableView.footerElementKind) {
            (supplementaryView, string, indexPath) in
            let footer = self.collectionView.dequeueReusableSupplementaryView(ofKind: TitleSupplementaryCollectionReusableView.footerElementKind,
                                                                              withReuseIdentifier: TitleSupplementaryCollectionReusableView.identifier,
                                                                              for: indexPath) as! TitleSupplementaryCollectionReusableView
            footer.configure(title: "\(string) for section \(indexPath.section)")
            footer.backgroundColor = .lightGray
            footer.layer.borderColor = UIColor.black.cgColor
            footer.layer.borderWidth = 1.0
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            let kind = kind == TitleSupplementaryCollectionReusableView.headerElementKind ? headerRegistration : footerRegistration
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: kind, for: index)
        }
        
        let itemsPerSection = 5
        let sections = Array(0..<5)
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var itemOffset = 0
        sections.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems(Array(itemOffset..<itemOffset + itemsPerSection))
            itemOffset += itemsPerSection
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension PinnedSectionHeaderFooterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
