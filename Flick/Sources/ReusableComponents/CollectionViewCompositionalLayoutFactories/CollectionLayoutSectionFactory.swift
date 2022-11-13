//
//  CollectionLayoutSectionFactory.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/11/2022.
//

import UIKit

enum CollectionLayoutSectionFactory {
    static func create(
        spacing: CGFloat,
        inset: CGFloat,
        group: NSCollectionLayoutGroup,
        orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none,
        boundarySupplementaryItems: [NSCollectionLayoutBoundarySupplementaryItem] = []
    ) -> NSCollectionLayoutSection {
        let top = boundarySupplementaryItems.isEmpty ? inset : 0
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = orthogonalScrollingBehavior
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: top, leading: inset, bottom: inset, trailing: inset)
        section.boundarySupplementaryItems = boundarySupplementaryItems
        return section
    }
}
