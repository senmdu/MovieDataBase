//
//  Genres.swift
//  PremierSwift
//
//  Created by Senthil Kumar on 27/04/23.
//  Copyright © 2023 Deliveroo. All rights reserved.
//

import Foundation


struct ResponseGenres : Decodable {
    let genres : [Genres]
}
struct Genres: Decodable {
    
    let id : Int
    let name : String
    
    private static var list : [Genres] = []
    
    private static var request: Request<ResponseGenres> {
        return Request(method: .get, path: "/genre/movie/list")
    }
    static func fetchGenres() {
        APIManager.shared.execute(Genres.request) {  result in
            guard case  .success (let generes) = result else { return }
            self.list = generes.genres
        }
    }
    
    public static func get(by ids:[Int]) -> String? {
        let filtered = self.list.filter{ids.contains($0.id)}.compactMap({$0.name})
        guard filtered.count > 0 else {return nil}
        return filtered.prefix(3).joined(separator: " • ")
    }
    
}
