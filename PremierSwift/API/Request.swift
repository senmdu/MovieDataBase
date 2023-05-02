import Foundation

enum Method: String {
    case get = "GET"
}

struct Request<Value> {
    
    var method: Method
    var path: String
    var queryParams: [String: Any]
    
    init(method: Method = .get, path: String, params: [String: String] = [:]) {
        self.method = method
        self.path = path
        self.queryParams = params
    }
    
}
