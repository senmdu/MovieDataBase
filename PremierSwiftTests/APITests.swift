import XCTest
@testable import PremierSwift

final class ApiTest: XCTestCase {
    
    // MARK: - Top Movies List Api Test
    
    func test_TopMovieList_Api_url_builder() {
        let request: Request<Page<Movie>> = Request(method: .get, path: "/movie/top_rated")
        let url = URL(APIManager.host, APIManager.apiKey, request)
        XCTAssertEqual(url.absoluteString, "https://api.themoviedb.org/3/movie/top_rated?api_key=\(APIManager.apiKey)")
    }
    
    
    func test_TopMovieList_Api_Response() {
        let expectation = self.expectation(description: "TopMovieListApi_Result_Valid")
        let request: Request<Page<Movie>> = Request(method: .get, path: "/movie/top_rated")
        let url = URL(APIManager.host, APIManager.apiKey, request)
        APIManager.shared.execute(request) { result in
            guard case .success(let movie) = result else {
                XCTFail("\(url.absoluteString) failed")
                return
            }
            XCTAssertGreaterThan(movie.results.count, 0, "Movies result is empty")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    // MARK: - Movie Detail Api Test
    
    func test_MovieDetails_Api_url_builder() {
        let movieId = 238
        
        let request: Request<MovieDetails> = Request(method: .get, path: "/movie/\(movieId)")
        let url = URL(APIManager.host, APIManager.apiKey, request)
        XCTAssertEqual(url.absoluteString, "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(APIManager.apiKey)")
    }
    
    
    func test_MovieDetails_Api_Response() {
        let movieId = 238
        let movieName = "The Godfather"
        
        let expectation = self.expectation(description: "MovieDetailsApi_Result_Valid")
        
        let request: Request<MovieDetails> = Request(method: .get, path: "/movie/\(movieId)")
        let url = URL(APIManager.host, APIManager.apiKey, request)
        APIManager.shared.execute(request) { result in
            guard case .success(let movie) = result else {
                XCTFail("\(url.absoluteString) failed")
                return
            }
            XCTAssertEqual(movie.title, movieName, "Movie detail api failed")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // MARK: - Similar Movies List Api Test
    
    func test_SimilarMoviesList_Api_url_builder() {
        let movieId = 238
        let request: Request<Page<Movie>> = Request(method: .get, path: "/movie/\(movieId)/similar")
        let url = URL(APIManager.host, APIManager.apiKey, request)
        XCTAssertEqual(url.absoluteString, "https://api.themoviedb.org/3/movie/\(movieId)/similar?api_key=\(APIManager.apiKey)")
    }
    
    
    func test_SimilarMoviesList_Api_Response() {
        let movieId = 238
        let expectation = self.expectation(description: "SimilarMoviesApi_Result_Valid")
        let request: Request<Page<Movie>> =  Request(method: .get, path: "/movie/\(movieId)/similar")
        let url = URL(APIManager.host, APIManager.apiKey, request)
        APIManager.shared.execute(request) { result in
            guard case .success(let response) = result else {
                XCTFail("\(url.absoluteString) failed")
                return
            }
            XCTAssertGreaterThan(response.results.count, 0, "Similar Movies list is empty")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // MARK: - Genres List Api Test
    
    func test_GenresList_Api_url_builder() {
        let request: Request<ResponseGenres> = Request(method: .get, path: "/genre/movie/list")
        let url = URL(APIManager.host, APIManager.apiKey, request)
        XCTAssertEqual(url.absoluteString, "https://api.themoviedb.org/3/genre/movie/list?api_key=\(APIManager.apiKey)")
    }
    
    
    func test_GenresList_Api_Response() {
        let expectation = self.expectation(description: "GenresListtApi_Result_Valid")
        let request: Request<ResponseGenres> = Request(method: .get, path: "/genre/movie/list")
        let url = URL(APIManager.host, APIManager.apiKey, request)
        APIManager.shared.execute(request) { result in
            guard case .success(let response) = result else {
                XCTFail("\(url.absoluteString) failed")
                return
            }
            XCTAssertGreaterThan(response.genres.count, 0, "Genres list is empty")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
