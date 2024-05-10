//
//  CollectionViewCellNib.swift
//  MRMovieWithPagination
//
//  Created by User on 5/10/24.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
}
