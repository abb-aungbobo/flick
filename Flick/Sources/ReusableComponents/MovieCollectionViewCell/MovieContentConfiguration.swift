//
//  MovieContentConfiguration.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import UIKit

struct MovieContentConfiguration: UIContentConfiguration, Hashable {
    var title: String?
    var posterURL: URL?
    
    func makeContentView() -> UIView & UIContentView {
        return MovieContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> MovieContentConfiguration {
        let updatedConfig = self
        return updatedConfig
    }
}
