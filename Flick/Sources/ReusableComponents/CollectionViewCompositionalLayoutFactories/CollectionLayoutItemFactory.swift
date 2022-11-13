//
//  CollectionLayoutItemFactory.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/11/2022.
//

import UIKit

enum CollectionLayoutItemFactory {
    static func create() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        return item
    }
}
