//
//  APICaller.swift
//  MRMovieWithPagination
//
//  Created by User on 5/10/24.
//

import Foundation
import Alamofire

enum MovieCategory: Int {
    case trendingMovies = 0
    case popularMovies = 1
    case upcomingMovies = 2
    case topRatedMovies = 3
    case discoverMovies = 4
    case searchMovies = 5
    
    func url(forPage page: Int = 1, with query: String = "") -> String {
        let base = "\(NetworkConstants.shared.baseURL)/3"
        let apiKeyParam = "?api_key=\(NetworkConstants.shared.apiKey)"
        let languagePage = "&language=en-US&page=\(page)"
        
        switch self {
        case .trendingMovies:
            return "\(base)/trending/movie/day\(apiKeyParam)"
        case .upcomingMovies:
            return "\(base)/movie/upcoming\(apiKeyParam)\(languagePage)"
        case .popularMovies:
            return "\(base)/movie/popular\(apiKeyParam)\(languagePage)"
        case .topRatedMovies:
            return "\(base)/movie/top_rated\(apiKeyParam)\(languagePage)"
        case .discoverMovies:
            return "\(base)/discover/movie\(apiKeyParam)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=\(page)&with_watch_monetization_types=flatrate"
        case .searchMovies:
            return "\(base)/search/movie\(apiKeyParam)&query=\(query)"
        }
    }
}


public class APICaller {
    static let shared = APICaller()
    
    func fetchMovies(for endpoint: MovieCategory, page: Int, onSuccess: @escaping (MovieResults) -> Void, onFailure: @escaping (Error) -> Void) {
        let urlString = endpoint.url(forPage: page)
        guard let url = URL(string: urlString) else {
            onFailure(NSError(domain: "APICaller", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        AF.request(url).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    onFailure(NSError(domain: "APICaller", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data returned from API"]))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let results = try decoder.decode(MovieResults.self, from: data)
                    onSuccess(results)
                } catch {
                    onFailure(error)
                }
            case .failure(let error):
                onFailure(error)
            }
        }
    }
    
    func search(with query: String, onSuccess: @escaping (MovieResults) -> Void, onFailure: @escaping (Error) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        let urlString = MovieCategory.searchMovies.url(with:query)
        guard let url = URL(string: urlString) else {
            onFailure(NSError(domain: "APICaller", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        AF.request(url).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else {
                    onFailure(NSError(domain: "APICaller", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data returned from API"]))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let results = try decoder.decode(MovieResults.self, from: data)
                    onSuccess(results)
                } catch {
                    onFailure(error)
                }
            case .failure(let error):
                onFailure(error)
            }
        }
    }
}


