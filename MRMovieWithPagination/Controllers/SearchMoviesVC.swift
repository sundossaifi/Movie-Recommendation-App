//
//  SearchMoviesVC.swift
//  MRMovieWithPagination
//
//  Created by User on 5/9/24.
//

import UIKit
import Toast

class SearchMoviesVC: UIViewController {
    
    @IBOutlet weak var discoverMoviesTable: UITableView!
    
    lazy private var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultVC())
        searchController.searchBar.placeholder = "Search for a Movie"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    
    let searchViewModel = SearchViewModel()
    let searchResultsViewModel = SearchResultsViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        searchViewModel.delegate = self
        searchResultsViewModel.delegate = self
        
        discoverMoviesTable.delegate = self
        discoverMoviesTable.dataSource = self
                
        discoverMoviesTable.register(SearchMovieTableViewCell.nib(), forCellReuseIdentifier: SearchMovieTableViewCell.identifier)
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        navigationController?.navigationBar.tintColor = .label
    }
}

extension SearchMoviesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.getMoviesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = discoverMoviesTable.dequeueReusableCell(withIdentifier: SearchMovieTableViewCell.identifier, for: indexPath) as? SearchMovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = searchViewModel.movies[indexPath.row]
        cell.configureCell(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension SearchMoviesVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultVC else {
            return
        }
        searchResultsViewModel.fetchSearchMovies(with: query) { movie in
            resultsController.movies = movie
        }
        resultsController.searchResultsCollectionView.reloadData()
    }
}

extension SearchMoviesVC: SearchViewModelDelegate, SearchResultsViewModelDelegate{
    func onFetchCompleted() {
        discoverMoviesTable.reloadData()
    }
    
    func onFetchFailed(with reason: String) {
        self.view.makeToast(reason)
    }
}
