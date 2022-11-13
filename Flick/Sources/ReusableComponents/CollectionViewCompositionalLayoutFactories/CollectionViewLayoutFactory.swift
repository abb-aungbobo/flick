//
//  CollectionViewLayoutFactory.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/11/2022.
//

import UIKit

enum CollectionViewLayoutFactory {
    private static let spacing: CGFloat = 8.0
    private static let inset: CGFloat = 16.0
    
    private static func create(section: NSCollectionLayoutSection) -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: configuration)
        return layout
    }
    
    static func create(
        view: UIView,
        orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
    ) -> UICollectionViewLayout {
        let item = CollectionLayoutItemFactory.create()
        let group = CollectionLayoutGroupFactory.create(view: view, item: item)
        let sectionHeader = CollectionLayoutBoundarySupplementaryItemFactory.create(heightDimension: .absolute(40.0))
        let section = CollectionLayoutSectionFactory.create(
            spacing: spacing,
            inset: inset,
            group: group,
            orthogonalScrollingBehavior: orthogonalScrollingBehavior,
            boundarySupplementaryItems: [sectionHeader]
        )
        return create(section: section)
    }
    
    static func create(
        view: UIView,
        boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
    ) -> UICollectionViewLayout {
        let item = CollectionLayoutItemFactory.create()
        let group = CollectionLayoutGroupFactory.create(count: 3, spacing: spacing, inset: inset, view: view, item: item)
        let section = CollectionLayoutSectionFactory.create(
            spacing: spacing,
            inset: inset,
            group: group,
            boundarySupplementaryItems: boundarySupplementaryItems
        )
        return create(section: section)
    }
    
    static func create() -> UICollectionViewLayout {
        let item = CollectionLayoutItemFactory.create()
        let group = CollectionLayoutGroupFactory.create(item: item)
        let sectionHeader = CollectionLayoutBoundarySupplementaryItemFactory.create(heightDimension: .absolute(40.0))
        let section = CollectionLayoutSectionFactory.create(
            spacing: spacing,
            inset: inset,
            group: group,
            boundarySupplementaryItems: [sectionHeader]
        )
        return create(section: section)
    }
}
