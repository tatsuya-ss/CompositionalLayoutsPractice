//
//  WWDC19CollectionViewController.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/08/23.
//

import UIKit

class WWDC19CollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let collectionTypeModel = CollectionViewTypeModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.register(WWDC19CollectionViewCell.nib,
                                forCellWithReuseIdentifier: WWDC19CollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        let collectionViewLayout = createLayout()
        collectionView.collectionViewLayout = collectionViewLayout
        
    }
    
}

extension WWDC19CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let typeCount = collectionTypeModel.returnNumberOfTypeCount()
        return typeCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WWDC19CollectionViewCell.identifier, for: indexPath) as! WWDC19CollectionViewCell
        let types = collectionTypeModel.returnTypes()
        cell.configure(title: types[indexPath.row])
        return cell
    }
}

extension WWDC19CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gridVC = GridViewController.instantiate()
        let twoColumnVC = TwoColumnViewController.instantiate()
        let distinctSectionsVC = DistinctSectionsViewController.instantiate()
        let adaptiveSectionsVC = AdaptiveSectionsViewController.instantiate()
        let viewControllers = [gridVC, twoColumnVC, distinctSectionsVC, adaptiveSectionsVC]
        present(viewControllers[indexPath.row], animated: true, completion: nil)
    }
}

extension WWDC19CollectionViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(1)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}
