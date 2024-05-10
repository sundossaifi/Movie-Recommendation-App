//
//  HomeViewModel.swift
//  MRMovieWithPagination
//
//  Created by User on 5/10/24.
//

import Foundation

protocol MoviesListViewModelDelegate: AnyObject {
    func onFetchCompleted()
    func onFetchFailed(with reason: String)
}

class HomeViewModel {
    let sectionTitles: [String] = ["Trending Movies", "Popular", "Upcoming Movies", "Top rated"]
    
    weak var delegate: MoviesListViewModelDelegate?
    var trendingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var upComingMovies: [Movie] = []
    var topRatedMovies: [Movie] = []
    var isTrendingFetchInProgress = false
    var isPopularFetchInProgress = false
    var isUpcomingFetchInProgress = false
    var isTopRatedFetchInProgress = false
    
    var trendingCurrentPage = 0
    var popularCurrentPage = 0
    var upcomingCurrentPage = 0
    var topRatedCurrentPage = 0
    
    var trendingTotalPages = 0
    var popularTotalPages = 0
    var upcomingTotalPages = 0
    var topRatedTotalPages = 0
    
    func getSectionsCount() -> Int {
        return sectionTitles.count
    }
    
    func getTrendingMoviesCount() -> Int {
        return trendingMovies.count
    }
    
    func getPopularMoviesCount() -> Int {
        return popularMovies.count
    }
    
    func getUpComingMoviesCount() -> Int {
        return upComingMovies.count
    }
    
    func getTopRatedMoviesCount() -> Int {
        return topRatedMovies.count
    }
    
    func fetchTrendingMovies(completion: @escaping (([Movie]) -> Void)) {
        guard !isTrendingFetchInProgress, trendingCurrentPage < trendingTotalPages || trendingCurrentPage == 0 else { return }
        isTrendingFetchInProgress = true
        let nextPage = trendingCurrentPage + 1
        
        APICaller.fetchMovies(for:.trendingMovies, page: nextPage) { [weak self] movieResults in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isTrendingFetchInProgress = false
                self.trendingTotalPages = movieResults.totalPages
                if nextPage == 1 {
                    self.trendingMovies = movieResults.results
                } else {
                    self.trendingMovies.append(contentsOf: movieResults.results)
                }
                self.trendingCurrentPage = nextPage
                self.delegate?.onFetchCompleted()
//                print(self.trendingMovies)
                completion(self.trendingMovies)
            }
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isTrendingFetchInProgress = false
                self.delegate?.onFetchFailed(with: error.localizedDescription)
            }
        }
    }
    
    func fetchPopularMovies(completion: @escaping (([Movie]) -> Void)) {
        guard !isPopularFetchInProgress, popularCurrentPage < popularTotalPages || popularCurrentPage == 0 else { return }
        isPopularFetchInProgress = true
        let nextPage = popularCurrentPage + 1
        
        APICaller.fetchMovies(for:.popularMovies, page: nextPage) { [weak self] movieResults in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isPopularFetchInProgress = false
                self.popularTotalPages = movieResults.totalPages
                if nextPage == 1 {
                    self.popularMovies = movieResults.results
                } else {
                    self.popularMovies.append(contentsOf: movieResults.results)
                }
                self.popularCurrentPage = nextPage
                self.delegate?.onFetchCompleted()
//                print(self.popularMovies)
                completion(self.popularMovies)
            }
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isPopularFetchInProgress = false
                self.delegate?.onFetchFailed(with: error.localizedDescription)
            }
        }
    }
    
    func fetchUpComingMovies(completion: @escaping (([Movie]) -> Void)) {
        guard !isUpcomingFetchInProgress, upcomingCurrentPage < upcomingTotalPages || upcomingCurrentPage == 0 else { return }
        isUpcomingFetchInProgress = true
        let nextPage = upcomingCurrentPage + 1
        
        APICaller.fetchMovies(for:.upcomingMovies, page: nextPage) { [weak self] movieResults in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isUpcomingFetchInProgress = false
                self.upcomingTotalPages = movieResults.totalPages
                if nextPage == 1 {
                    self.upComingMovies = movieResults.results
                } else {
                    self.upComingMovies.append(contentsOf: movieResults.results)
                }
                self.upcomingCurrentPage = nextPage
                self.delegate?.onFetchCompleted()
                completion(self.upComingMovies)
            }
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isUpcomingFetchInProgress = false
                self.delegate?.onFetchFailed(with: error.localizedDescription)
            }
        }
    }
    
    func fetchTopRatedMovies(completion: @escaping (([Movie]) -> Void)) {
        guard !isTopRatedFetchInProgress, topRatedCurrentPage < topRatedTotalPages || topRatedCurrentPage == 0 else { return }
        isTopRatedFetchInProgress = true
        let nextPage = topRatedCurrentPage + 1
        
        APICaller.fetchMovies(for:.topRatedMovies, page: nextPage) { [weak self] movieResults in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isTopRatedFetchInProgress = false
                self.topRatedTotalPages = movieResults.totalPages
                if nextPage == 1 {
                    self.topRatedMovies = movieResults.results
                } else {
                    self.topRatedMovies.append(contentsOf: movieResults.results)
                }
                self.topRatedCurrentPage = nextPage
                self.delegate?.onFetchCompleted()
                completion(self.topRatedMovies)
            }
        } onFailure: { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isTopRatedFetchInProgress = false
                self.delegate?.onFetchFailed(with: error.localizedDescription)
            }
        }
    }
    
    func fetchNextMovies() {
        // Determine which category needs more data
        if isTrendingFetchInProgress {
            fetchTrendingMovies { _ in }
        }
        else if isPopularFetchInProgress {
            fetchPopularMovies { _ in }
        }
        else if isUpcomingFetchInProgress {
            fetchUpComingMovies { _ in }
        }
        else if isTopRatedFetchInProgress {
            fetchTopRatedMovies { _ in }
        }
    }
}
