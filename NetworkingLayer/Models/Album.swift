//
//  Album.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/13/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

struct Album: Codable {
    let artist: String
    let name: String
    let previewURL: String
    let coverURL:String
    let collectionID: Int
}

extension Album {
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case previewURL = "previewUrl"
        case coverURL = "artworkUrl60"
        case collectionID = "collectionId"
    }
}


