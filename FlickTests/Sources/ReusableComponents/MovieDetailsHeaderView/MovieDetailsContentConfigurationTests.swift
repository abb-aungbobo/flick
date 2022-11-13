//
//  MovieDetailsContentConfigurationTests.swift
//  FlickTests
//
//  Created by Aung Bo Bo on 28/08/2022.
//

@testable import Flick
import XCTest

class MovieDetailsContentConfigurationTests: XCTestCase {
    func test_voteAverage_withZero_shouldBeNotRated() {
        let movieDetails = MovieDetails.fake1
        let configuration = movieDetails.toMovieDetailsContentConfiguration()
        XCTAssertEqual(configuration.voteAverage, "Not Rated")
    }
    
    func test_voteAverage_withGreaterThanZero_shouldBeNumberPercentUserScore() {
        let movieDetails = MovieDetails.fake2
        let configuration = movieDetails.toMovieDetailsContentConfiguration()
        XCTAssertEqual(configuration.voteAverage, "97% User Score")
    }
}
