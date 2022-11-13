//
//  CreditsViewModel.swift
//  Flick
//
//  Created by Aung Bo Bo on 12/04/2022.
//

import Foundation

class CreditsViewModel {
    struct Dependency {
        let movieDetails: MovieDetails
        let credits: Credits
    }
    
    enum Section: String, CaseIterable {
        case cast = "Cast"
        case crew = "Crew"
    }
    
    let movieDetails: MovieDetails
    let cast: [Member]
    let crew: [Member]
    
    init(dependency: Dependency) {
        self.movieDetails = dependency.movieDetails
        self.cast = dependency.credits.cast
        self.crew = dependency.credits.crew
    }
}
