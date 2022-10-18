//
//  Extensions.swift
//  NetflixClone
//
//  Created by Cüneyt Erçel on 29.09.2022.
//

import Foundation

// ilk harf büyük sonra küçük yapma extensionu bunu homeviewcontrollerda, willdisplayheaderview kısmında kulllanıyoruz.
extension String {
    func capitalizeFirstLetter () -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
        
    }
}
