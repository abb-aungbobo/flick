//
//  MovieCollectionViewCell.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    var configuration: MovieContentConfiguration!
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = MovieContentConfiguration().updated(for: state)
        newConfiguration.title = configuration.title
        newConfiguration.posterURL = configuration.posterURL
        contentConfiguration = newConfiguration
    }
}
