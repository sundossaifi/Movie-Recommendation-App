//
//  NetworkConstants.swift
//  MRMovieWithPagination
//
//  Created by User on 5/10/24.
//

import Foundation

class NetworkConstants {
    public static var shared: NetworkConstants = NetworkConstants()
    
    private init() {
        
    }
    
    public var apiKey: String {
        get {
            return "8fa7b4de8ca2753872da0c066173dce1"
        }
    }
    
    public var baseURL: String {
        get {
            return "https://api.themoviedb.org"
        }
    }
    
    public var posterURL: String {
        get {
            return "https://image.tmdb.org/t/p/w300"
        }
    }
}
