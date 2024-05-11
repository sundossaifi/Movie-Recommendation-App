//
//  SearchResultsVC.swift
//  MRMovieWithPagination
//
//  Created by User on 5/11/24.
//

import UIKit

class SearchResultVC: UIViewController {
    
    lazy public var searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let searchResultsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        searchResultsCollectionView.register(MovieCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return searchResultsCollectionView
    }()
    
    let viewModel = SearchResultsViewModel()
    var movies: [Movie] = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
   private func configure() {
       view.backgroundColor = .systemBackground
       view.addSubview(searchResultsCollectionView)
       
       searchResultsCollectionView.dataSource = self
       searchResultsCollectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
}

extension SearchResultVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchResultsCollectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let posterURL = movies[indexPath.row].fullPosterURL else {
            return UICollectionViewCell()
        }
        cell.configureCollectionViewCell(with: posterURL)
        return cell
    }
}
