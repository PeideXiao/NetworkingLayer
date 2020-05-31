//
//  User.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/13/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

struct User {
    let name: String?
    let profileImageURL: URL?
    let reputation: Int?
}


struct Question {
    let score: Int
    let title: String
    let date: Date
    let tags: [String]
    let owner: User?
}


extension User: Decodable {
    enum CodingKeys:String, CodingKey {
        case reputation
        case name = "display_name"
        case profileImageURL = "profile_image"
    }
}

extension Question: Decodable {
    enum CodingKeys:String, CodingKey {
        case score
        case title
        case date = "creation_date"
        case tags
        case owner

    }
}


struct Wrapper<T: Decodable>: Decodable {
    var data:[T]
}
