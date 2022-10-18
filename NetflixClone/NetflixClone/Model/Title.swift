//
//  Movie.swift
//  NetflixClone
//
//  Created by Cüneyt Erçel on 28.09.2022.
//

import Foundation

/*Hem Movie Hem TV kısmını ayrı ayrı yapmıştık.
let results : [Movie]
let results : [Tv] yazıyordu ikisini de değiştirip Title diye değiştirdik. */

struct TrendingTitleResponse : Codable {
    
    let results : [Title]
}

struct Title : Codable {
    
    let id : Int
    let media_type : String?
    let original_name : String?
    let original_title : String?
    let poster_path : String?
    let overview : String?
    let vote_count : Int
    let release_date : String?
    let vote_average : Double
    
}
