//
//  SearchViewModel.swift
//  MRMovieWithPagination
//
//  Created by User on 5/11/24.
//

import UIKit

protocol SearchViewModelDelegate: AnyObject {
    func onFetchCompleted()
    func onFetchFailed(with reason: String)
}

class SearchViewModel {
    var movies: [Movie] = [Movie]()
    private var currentPage: Int = 0
    private var totalPages: Int = 0
    private var isFetchInProgress: Bool = false
    weak var delegate: SearchViewModelDelegate?
    
    init () {
        fetchDiscoverMovies()
    }

    func getMoviesCount() -> Int {
        return movies.count
    }
    
    func fetchDiscoverMovies() {
        guard !isFetchInProgress, (currentPage < totalPages) || (currentPage == 0 && totalPages == 0) else { return }
        
        isFetchInProgress = true
        let nextPage = currentPage + 1
        
        APICaller.shared.fetchMovies(for: .discoverMovies, page: nextPage, onSuccess: { [weak self] movieResults in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetchInProgress = false
                self.totalPages = movieResults.totalPages
                if nextPage == 1 {
                    self.movies = movieResults.results
                } else {
                    self.movies.append(contentsOf: movieResults.results)
                }
                self.currentPage = nextPage
                self.delegate?.onFetchCompleted()
            }
        }, onFailure: { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetchInProgress = false
                self.delegate?.onFetchFailed(with: error.localizedDescription)
            }
        })
    }
}
