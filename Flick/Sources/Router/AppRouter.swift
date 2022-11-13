//
//  AppRouter.swift
//  Flick
//
//  Created by Aung Bo Bo on 11/04/2022.
//

import UIKit

class AppRouter {
    enum Destination {
        case favorites
        case movieSearch
        case movieDetails(MovieDetailsViewModel.Dependency)
        case credits(CreditsViewModel.Dependency)
    }
    
    func route(from sourceViewController: UIViewController, to destination: Destination) {
        switch destination {
        case .favorites:
            let destinationViewController = FavoritesScene.create()
            sourceViewController.navigationController?.pushViewController(destinationViewController, animated: true)
        case .movieSearch:
            let destinationViewController = MovieSearchSecene.create()
            sourceViewController.navigationController?.pushViewController(destinationViewController, animated: true)
        case let .movieDetails(dependency):
            let destinationViewController = MovieDetailsScene.create(dependency: dependency)
            sourceViewController.navigationController?.pushViewController(destinationViewController, animated: true)
        case let .credits(dependency):
            let destinationViewController = CreditsScene.create(dependency: dependency)
            sourceViewController.navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
}
