//
//  HomeViewModel.swift
//  MRMovieWithPagination
//
//  Created by User on 5/10/24.
//

import Foundation

protocol MoviesListViewModelDelegate: AnyObject {
    func onFetchFailed(with reason: String)
}

class HomeViewModel {
    let sectionTitles: [String] = ["Trending Movies", "Popular", "Upcoming Movies", "Top rated"]
    weak var delegate: MoviesListViewModelDelegate?

    private var movies: [MovieCategory: [Movie]] = [.trendingMovies: [], .popularMovies: [], .upcomingMovies: [], .topRatedMovies: []]
    private var currentPage: [MovieCategory: Int] = [.trendingMovies: 0, .popularMovies: 0, .upcomingMovies: 0, .topRatedMovies: 0]
    private var totalPages: [MovieCategory: Int] = [.trendingMovies: 0, .popularMovies: 0, .upcomingMovies: 0, .topRatedMovies: 0]
    private var isFetchInProgress: [MovieCategory: Bool] = [.trendingMovies: false, .popularMovies: false, .upcomingMovies: false, .topRatedMovies: false]

    func getSectionsCount() -> Int {
        return sectionTitles.count
    }

    func getMoviesCount(for endpoint: MovieCategory) -> Int {
        return movies[endpoint]?.count ?? 0
    }

    func fetchMovies(for endpoint: MovieCategory, completion: @escaping ([Movie]) -> Void) {
        guard !(isFetchInProgress[endpoint] ?? true), (currentPage[endpoint] ?? 0) < (totalPages[endpoint] ?? 0) || (currentPage[endpoint] == 0) else { return }
        
        isFetchInProgress[endpoint] = true
        let nextPage = (currentPage[endpoint] ?? 0) + 1
        
        APICaller.shared.fetchMovies(for: endpoint, page: nextPage) { [weak self] movieResults in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetchInProgress[endpoint] = false
                self.totalPages[endpoint] = movieResults.totalPages
                if nextPage == 1 {
                    self.movies[endpoint] = movieResults.results
                } else {
                    self.movies[endpoint]?.append(contentsOf: movieResults.results)
                }
                self.currentPage[endpoint] = nextPage
                completion(self.movies[endpoint] ?? [])
            }
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetchInProgress[endpoint] = false
                self.delegate?.onFetchFailed(with: error.localizedDescription)
            }
        }
    }
}
