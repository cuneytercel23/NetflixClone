//
//  YoutubeSearchResponse.swift
//  NetflixClone
//
//  Created by Cüneyt Erçel on 8.10.2022.
//

import Foundation

struct YoutubeSearchResponse : Codable {
    let items : [VideoElement] //Videoelementi biz verdik items zorunlu
}

struct VideoElement : Codable {
    let id : IdVideoElement
}

struct IdVideoElement : Codable {
    let kind: String
    let videoId : String
}
