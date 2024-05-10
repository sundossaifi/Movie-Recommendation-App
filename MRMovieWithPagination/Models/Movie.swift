//
//  Movie.swift
//  MRMovieWithPagination
//
//  Created by User on 5/10/24.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String
    let releaseDate: String
    let voteAverage: Double
    let overview: String
    let originalTitle: String
    let originalLanguage: String
    let backdropPath: String?
    let popularity: Double
    let video: Bool
    let voteCount: Int
    let genreIds: [Int]
    let adult: Bool
    
    var fullPosterURL: URL? {
        let posterBaseUrl = NetworkConstants.shared.posterURL
        return URL(string: posterBaseUrl + posterPath)
    }
    
    var formattedVoteAverage: String {
        return String(format: "%.1f", voteAverage)
    }
}
