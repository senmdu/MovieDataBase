import Foundation

import Foundation

struct MovieDetails: Decodable {
    
    let title: String
    let overview: String
    let backdropPath: String?
    let tagline: String?
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case backdropPath = "backdrop_path"
        case tagline
        case posterPath = "poster_path"
    }
    
}

extension MovieDetails {
    static func details(for movie: Movie) -> Request<MovieDetails> {
        return Request(method: .get, path: "/movie/\(movie.id)")
    }
}
