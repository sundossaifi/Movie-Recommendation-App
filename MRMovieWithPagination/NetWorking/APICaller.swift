//
//  APICaller.swift
//  MRMovieWithPagination
//
//  Created by User on 5/10/24.
//

import Foundation
import Alamofire

enum Endpoint: Int {
    case trendingMovies = 0
    case popularMovies = 1
    case upcomingMovies = 2
    case topRatedMovies = 3

    func url(forPage page: Int) -> String {
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
        }
    }
}

public class APICaller {
     static func fetchMovies(for endpoint: Endpoint, page: Int, onSuccess: @escaping (MovieResults) -> Void, onFailure: @escaping (Error) -> Void) {
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
}
