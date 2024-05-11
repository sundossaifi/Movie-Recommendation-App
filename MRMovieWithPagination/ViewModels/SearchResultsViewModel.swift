//
//  SearchResultsViewModel.swift
//  MRMovieWithPagination
//
//  Created by User on 5/11/24.
//

import Foundation

protocol SearchResultsViewModelDelegate: AnyObject {
    func onFetchCompleted()
    func onFetchFailed(with reason: String)
}

class SearchResultsViewModel {
    var movies: [Movie] = [Movie]()
    var isFetchInProgress:Bool = false
    var delegate: SearchResultsViewModelDelegate?
    
    func fetchSearchMovies(with query: String, completion: @escaping ([Movie]) -> Void) {
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        
        APICaller.shared.search(with: query, onSuccess: { [weak self] movieResults in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetchInProgress = false
                self.movies = movieResults.results
                self.delegate?.onFetchCompleted()
                completion(self.movies)
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
