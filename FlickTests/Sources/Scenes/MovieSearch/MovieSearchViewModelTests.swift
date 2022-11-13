//
//  MovieSearchViewModelTests.swift
//  FlickTests
//
//  Created by Aung Bo Bo on 09/11/2022.
//

@testable import Flick
import XCTest

final class MovieSearchViewModelTests: XCTestCase {
    private var sut: MovieSearchViewModel!
    private let query = "zootopia"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let searchService = SearchServiceMock()
        sut = MovieSearchViewModel(searchService: searchService)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_state_whenSearchMovies_shouldBeIdleAndSucceeded() async {
        let expected: [MovieSearchViewModel.State] = [.idle, .succeeded]
        var results: [MovieSearchViewModel.State] = []
        
        sut.state
            .sink { state in
                results.append(state)
            }
            .store(in: &sut.cancellables)
        
        await sut.searchMovies(query: query)
        
        XCTAssert(expected == results, "Results expected to be \(expected) but were \(results)")
    }
    
    func test_movies_whenSearchMovies_shouldNotBeEmpty() async {
        await sut.searchMovies(query: query)
        XCTAssertFalse(sut.movies.isEmpty)
    }
}
