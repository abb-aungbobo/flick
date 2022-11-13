//
//  CollectionLayoutBoundarySupplementaryItemFactory.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/11/2022.
//

import UIKit

enum CollectionLayoutBoundarySupplementaryItemFactory {
    static func create(heightDimension height: NSCollectionLayoutDimension) -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: height)
        let elementKind = UICollectionView.elementKindSectionHeader
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: elementKind, alignment: .top)
        return sectionHeader
    }
}
