//
//  CreditsViewModelTests.swift
//  FlickTests
//
//  Created by Aung Bo Bo on 09/11/2022.
//

@testable import Flick
import XCTest

final class CreditsViewModelTests: XCTestCase {
    private var sut: CreditsViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let movieDetailsResponse: MovieDetailsResponse = try! JSON.decode(from: "details")
        let creditsResponse: CreditsResponse = try! JSON.decode(from: "credits")
        let movieDetails = movieDetailsResponse.toMovieDetails()
        let credits = creditsResponse.toCredits()
        let dependency = CreditsViewModel.Dependency(movieDetails: movieDetails, credits: credits)
        sut = CreditsViewModel(dependency: dependency)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_cast_shouldNotBeEmpty() {
        XCTAssertFalse(sut.cast.isEmpty)
    }
    
    func test_crew_shouldNotBeEmpty() {
        XCTAssertFalse(sut.crew.isEmpty)
    }
}
