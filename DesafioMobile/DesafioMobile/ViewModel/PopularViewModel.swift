//
//  PopularViewModel.swift
//  DesafioMobile
//
//  Created by Eric Winston on 8/27/19.
//  Copyright © 2019 Eric Winston. All rights reserved.
//

import UIKit


//MARK: - Interface
protocol PopularInterface: class{
    var pageCount: Int {get set}
    var movies: [PresentableMovieInterface] {get set}
    func loadMovies(type: String)
    func resetMovies()
}


//MARK: - Init
class PopularViewModel{
    public var pageCount = 0
    weak var refreshDelegate: PopularGridViewModelDelegate?
    var apiAccess: APIClientInterface
    var atualType: String = "popular"
    
    
    var movies: [PresentableMovieInterface] = [] {
        didSet{
            refreshDelegate?.refreshMovieData()
        }
    }
    
    init(apiAccess: APIClientInterface) {
        self.apiAccess = apiAccess
        loadMovies(type: atualType)
    }
}


//MARK: - Methods
extension PopularViewModel: PopularInterface{
    
    //Loads the movie banner from the api
    func loadImage(path: String, completion: @escaping (UIImage) -> Void ){
        apiAccess.downloadImage(path: path) { (fetchedImage) in
            if let image = fetchedImage{
                completion(image)
            }
        }
    }
    
    //Loads the movies from the API
    func loadMovies(type: String){
        pageCount += 1
        
        apiAccess.fetchData(path: ApiPaths.movies(page: pageCount,type: type), type: Populares.self) { [weak self] (fetchedMovies,error) in
            guard let checkMovies = fetchedMovies.results else {fatalError("Error fetching the movies form the API")}
            if error == nil {
                checkMovies.forEach({ (movie) in
                    if let path = movie.poster_path{
                        self?.loadImage(path: path, completion: { [weak self] (image) in
                            self?.movies.append(PresentableMovie(movieID: movie.id, movieTitle: movie.title, movieOverview: movie.overview, movieGenres: movie.genre_ids, movieDate: movie.release_date, image: image))
                            
                        })
                    }
                })
            }else{
                self?.movies = []
            }
        }
    }
    
    //Reset the movie array
    func resetMovies(){
        pageCount = 0
        movies.removeAll()
        
        if atualType == "popular" {
            atualType = "upcoming"
        }else{
            atualType = "popular"
        }
    }
}

