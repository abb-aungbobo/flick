//
//  MemberContentConfiguration.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import UIKit

struct MemberContentConfiguration: UIContentConfiguration, Hashable {
    var name: String?
    var characterOrJob: String?
    
    func makeContentView() -> UIView & UIContentView {
        return MemberContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> MemberContentConfiguration {
        let updatedConfig = self
        return updatedConfig
    }
}
