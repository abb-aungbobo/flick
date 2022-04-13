//
//  MemberCollectionViewCell.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import UIKit

class MemberCollectionViewCell: UICollectionViewCell {
    var configuration: MemberContentConfiguration!
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = MemberContentConfiguration().updated(for: state)
        newConfiguration.name = configuration.name
        newConfiguration.characterOrJob = configuration.characterOrJob
        contentConfiguration = newConfiguration
    }
}
