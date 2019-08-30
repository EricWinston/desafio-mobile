//
//  Movie.swift
//  DesafioMobile
//
//  Created by Eric Winston on 8/27/19.
//  Copyright © 2019 Eric Winston. All rights reserved.
//

struct Populares: Codable{
    var page: Int
    var results: [Movie]?
    var total_results: Int
    var total_pages: Int
}


//Movie in the API
class Movie: Codable{
    let poster_path: String?
    var overview: String
    var release_date: String
    var genre_ids: [Int]
    let id: Int
    var title: String
    var backdrop_path: String?
}


class DetailedMovie: Codable{
    var runtime: Int?
    var genres: [Genre]?
}
