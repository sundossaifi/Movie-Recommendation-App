//
//  CollectionViewTableViewCell.swift
//  MRMovieWithPagination
//
//  Created by User on 5/9/24.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    private var movies: [Movie] = [Movie]()
    var viewModel: HomeViewModel?
    var section: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func configure() {
        moviesCollectionView.register(MovieCollectionViewCell.nib(), forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public func configureCell(with movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async { [weak self] in
            self?.moviesCollectionView.reloadData()
        }
    }
    
    func fetchMovies() {
        guard let section = section else {
            return
        }
        guard let endpoint = MovieCategory(rawValue: section) else { return }
        viewModel?.fetchMovies(for: endpoint) { movies in
            self.configureCell(with: movies)
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let posterURL = movies[indexPath.row].fullPosterURL else {
            return UICollectionViewCell()
        }
        cell.configureCollectionViewCell(with: posterURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == movies.count - 1 {
            self.fetchMovies()
        }
    }
}
    

