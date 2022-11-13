//
//  MoviesViewModelTests.swift
//  FlickTests
//
//  Created by Aung Bo Bo on 09/11/2022.
//

@testable import Flick
import XCTest

final class MoviesViewModelTests: XCTestCase {
    private var sut: MoviesViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let movieService = MovieServiceMock()
        sut = MoviesViewModel(movieService: movieService)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_state_whenGetMovies_shouldBeIdleAndSucceeded() async {
        let expected: [MoviesViewModel.State] = [.idle, .succeeded]
        var results: [MoviesViewModel.State] = []
        
        sut.state
            .sink { state in
                results.append(state)
            }
            .store(in: &sut.cancellables)
        
        await sut.getMovies()
        
        XCTAssert(expected == results, "Results expected to be \(expected) but were \(results)")
    }
    
    func test_nowPlayingMovies_whenGetMovies_shouldNotBeEmpty() async {
        await sut.getMovies()
        XCTAssertFalse(sut.nowPlayingMovies.isEmpty)
    }
    
    func test_popularMovies_whenGetMovies_shouldNotBeEmpty() async {
        await sut.getMovies()
        XCTAssertFalse(sut.popularMovies.isEmpty)
    }
    
    func test_topRatedMovies_whenGetMovies_shouldNotBeEmpty() async {
        await sut.getMovies()
        XCTAssertFalse(sut.topRatedMovies.isEmpty)
    }
    
    func test_upcomingMovies_whenGetMovies_shouldNotBeEmpty() async {
        await sut.getMovies()
        XCTAssertFalse(sut.upcomingMovies.isEmpty)
    }
}
