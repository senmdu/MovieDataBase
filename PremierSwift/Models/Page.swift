import Foundation

struct Page<T: Decodable>: Decodable {
    
    var pageNumber: Int
    var totalResults: Int
    var totalPages: Int
    var results: [T]
    var id : Int?
    
    var isPagigNating : Bool = false
    
    enum CodingKeys: String, CodingKey {
        case pageNumber = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
        case id
    }
    
    var canPagignate : Bool {
        totalPages > 0 && pageNumber < totalPages
    }
    
    
    
}
