//
//  ItemBadgesViewController.swift
//  CompositionalLayoutPractice
//
//  Created by 坂本龍哉 on 2021/09/02.
//

import UIKit

final class ItemBadgesViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    struct Model: Hashable {
        let title: String
        let badgeCount: Int

        let identifier = UUID()
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
        }
    }
    
    struct ElementKind {
        static let badge = "badge-element-kind"
        static let background = "background-element-kind"
        static let sectionHeader = "section-header-element-kind"
        static let sectionFooter = "section-footer-element-kind"
        static let layoutHeader = "layout-header-element-kind"
        static let layoutFooter = "layout-footer-element-kind"
    }

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private let numbers = NumberModel().getNumbers()
    var dataSource: UICollectionViewDiffableDataSource<Section, Model>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureDataSource()
        
    }
    
}

extension ItemBadgesViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing],
                                                  fractionalOffset: CGPoint(x: 0.3, y: -0.3))
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20),
                                               heightDimension: .absolute(20))
        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize,
                                                        elementKind: ElementKind.badge,
                                                        containerAnchor: badgeAnchor)
        
        let checkBadgeAnchor = NSCollectionLayoutAnchor(edges: [.bottom, .leading],
                                                        fractionalOffset: CGPoint(x: 0.3, y: -0.3))
        let checkbadge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize,
                                                             elementKind: ElementKind.layoutFooter,
                                                             containerAnchor: checkBadgeAnchor)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge, checkbadge])
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }

}

extension ItemBadgesViewController {
    func configureHierarchy() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ItemBadgesCollectionViewCell.nib,
                                forCellWithReuseIdentifier: ItemBadgesCollectionViewCell.identifier)
    }
    
    func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, Model>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, model: Model) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemBadgesCollectionViewCell.identifier,
                                                          for: indexPath) as! ItemBadgesCollectionViewCell
            cell.configure(number: self.numbers[indexPath.row])
            return cell
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration<BadgeSupplementaryView>(elementKind: BadgeSupplementaryView.reuseIdentifier) {
            (badgeView, string, indexPath) in
            guard let model = self.dataSource.itemIdentifier(for: indexPath) else { return }
            let hasBadgeCount = model.badgeCount > 0
            badgeView.label.text = "\(model.badgeCount)"
            badgeView.isHidden = !hasBadgeCount
        }

        dataSource.supplementaryViewProvider = {
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: $2)
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Model>()
        snapshot.appendSections([.main])
        let models = numbers.map { Model(title: "\($0)", badgeCount: Int.random(in: 0..<3)) }
        snapshot.appendItems(models)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension UIColor {
    static var cornflowerBlue: UIColor {
        return UIColor(displayP3Red: 100.0 / 255.0, green: 149.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
    }
}

// MARK: - BadgeSupplementaryView
final class BadgeSupplementaryView: UICollectionReusableView {

    static let reuseIdentifier = "badge-reuse-identifier"
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    override var frame: CGRect {
        didSet {
            configureBorder()
        }
    }
    override var bounds: CGRect {
        didSet {
            configureBorder()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

extension BadgeSupplementaryView {
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .black
        backgroundColor = .green
        configureBorder()
    }
    func configureBorder() {
        let radius = bounds.width / 2.0
        layer.cornerRadius = radius
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
    }
}
