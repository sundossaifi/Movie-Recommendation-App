//
//  SearchMovieTableViewCell.swift
//  MRMovieWithPagination
//
//  Created by User on 5/11/24.
//

import UIKit

class SearchMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configureCell(with movie: Movie) {
        moviePosterImageView.kf.setImage(with: movie.fullPosterURL)
        movieTitle.text = movie.title
    }
}
