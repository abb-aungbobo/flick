//
//  CollectionLayoutGroupFactory.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/11/2022.
//

import UIKit

enum CollectionLayoutGroupFactory {
    static func create(view: UIView, item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        let height: CGFloat = view.frame.height / 4
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(height * 2/3), heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        return group
    }
    
    static func create(count: Int, spacing: CGFloat, inset: CGFloat, view: UIView, item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        let totalInset = 2 * inset
        let totalSpacing = CGFloat(count - 1) * spacing
        let width = (view.frame.width - totalInset - totalSpacing) / CGFloat(count)
        let height = width * 3/2
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(CGFloat(width)), heightDimension: .absolute(CGFloat(height)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: count)
        group.interItemSpacing = .fixed(spacing)
        return group
    }
    
    static func create(item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        return group
    }
}
