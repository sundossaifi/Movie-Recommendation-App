//
//  CapitalizeFirstLetter.swift
//  MRMovieWithPagination
//
//  Created by User on 5/10/24.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
