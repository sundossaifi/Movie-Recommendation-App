//
//  MovieResults.swift
//  MRMovieWithPagination
//
//  Created by User on 5/10/24.
//

import Foundation

struct MovieResults: Codable {
    let results: [Movie]
    let page: Int
    let totalPages: Int
    let totalResults: Int
}
