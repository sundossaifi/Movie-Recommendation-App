//
//  MovieCollectionViewCell.swift
//  MRMovieWithPagination
//
//  Created by User on 5/10/24.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var moviePosterImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configureCollectionViewCell(with moviePoster: URL) {
        moviePosterImageView.kf.setImage(with: moviePoster)
    }
}
