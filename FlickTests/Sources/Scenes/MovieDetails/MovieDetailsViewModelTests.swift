//
//  MovieDetailsViewModelTests.swift
//  FlickTests
//
//  Created by Aung Bo Bo on 09/11/2022.
//

@testable import Flick
import XCTest

final class MovieDetailsViewModelTests: XCTestCase {
    private var sut: MovieDetailsViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let dependency = MovieDetailsViewModel.Dependency(id: .zero)
        let movieService = MovieServiceMock()
        let favoriteService = FavoriteServiceMock()
        sut = MovieDetailsViewModel(dependency: dependency, movieService: movieService, favoriteService: favoriteService)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_state_whenGetMovieDetails_shouldBeIdleAndSucceeded() async {
        let expected: [MovieDetailsViewModel.State] = [.idle, .succeeded]
        var results: [MovieDetailsViewModel.State] = []
        
        sut.state
            .sink { state in
                results.append(state)
            }
            .store(in: &sut.cancellables)
        
        await sut.getMovieDetails()
        
        XCTAssert(expected == results, "Results expected to be \(expected) but were \(results)")
    }
    
    func test_state_whenGetMovieDetailsAndFavorite_shouldBeIdleAndSucceededAndFavorite() async {
        let expected: [MovieDetailsViewModel.State] = [.idle, .succeeded, .favorite]
        var results: [MovieDetailsViewModel.State] = []
        
        sut.state
            .sink { state in
                results.append(state)
            }
            .store(in: &sut.cancellables)
        
        await sut.getMovieDetails()
        sut.favorite()
        
        XCTAssert(expected == results, "Results expected to be \(expected) but were \(results)")
    }
    
    func test_state_whenGetMovieDetailsAndUnfavorite_shouldBeIdleAndSucceededAndUnfavorite() async {
        let expected: [MovieDetailsViewModel.State] = [.idle, .succeeded, .unfavorite]
        var results: [MovieDetailsViewModel.State] = []
        
        sut.state
            .sink { state in
                results.append(state)
            }
            .store(in: &sut.cancellables)
        
        await sut.getMovieDetails()
        sut.unfavorite()
        
        XCTAssert(expected == results, "Results expected to be \(expected) but were \(results)")
    }
    
    func test_video_whenGetMovieDetails_shouldNotBeNil() async {
        await sut.getMovieDetails()
        XCTAssertNotNil(sut.video)
    }
    
    func test_movieDetails_whenGetMovieDetails_shouldNotBeNil() async {
        await sut.getMovieDetails()
        XCTAssertNotNil(sut.movieDetails)
    }
    
    func test_credits_whenGetMovieDetails_shouldNotBeNil() async {
        await sut.getMovieDetails()
        XCTAssertNotNil(sut.credits)
    }
    
    func test_similarMovies_whenGetMovieDetails_shouldNotBeEmpty() async {
        await sut.getMovieDetails()
        XCTAssertFalse(sut.similarMovies.isEmpty)
    }
    
    func test_isFavorite_whenGetMovieDetails_shouldBeTrue() async {
        await sut.getMovieDetails()
        XCTAssertTrue(sut.isFavorite)
    }
    
    func test_isFavorite_whenGetMovieDetailsAndUnfavorite_shouldBeFalse() async {
        await sut.getMovieDetails()
        sut.unfavorite()
        XCTAssertFalse(sut.isFavorite)
    }
    
    func test_favoriteImage_whenGetMovieDetails_shouldBeHeartFill() async {
        await sut.getMovieDetails()
        XCTAssert(sut.favoriteImage == UIImage(systemName: "heart.fill"))
    }
    
    func test_favoriteImage_whenGetMovieDetailsAndUnfavorite_shouldBeHeart() async {
        await sut.getMovieDetails()
        sut.unfavorite()
        XCTAssert(sut.favoriteImage == UIImage(systemName: "heart"))
    }
    
    func test_hideVideo_whenGetMovieDetails_shouldBeFalse() async {
        await sut.getMovieDetails()
        XCTAssertFalse(sut.hideVideo)
    }
    
    func test_toMovieDetailsContentConfiguration_whenGetMovieDetails_shouldNotBeNil() async {
        await sut.getMovieDetails()
        XCTAssertNotNil(sut.toMovieDetailsContentConfiguration())
    }
    
    func test_toCreditsViewModelDependency_whenGetMovieDetails_shouldNotBeNil() async {
        await sut.getMovieDetails()
        XCTAssertNotNil(sut.toCreditsViewModelDependency())
    }
}
