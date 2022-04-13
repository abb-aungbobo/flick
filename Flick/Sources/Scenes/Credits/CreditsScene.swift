//
//  CreditsScene.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Foundation

enum CreditsScene {
    static func create(dependency: CreditsViewModel.Dependency) -> CreditsViewController {
        let viewModel = CreditsViewModel(dependency: dependency)
        let router = AppRouter()
        let viewController = CreditsViewController(viewModel: viewModel, router: router)
        return viewController
    }
}
