//
//  MobleTheme.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/31/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

struct ArrayWrapper<T: Decodable> : Decodable {
    let data:[T]
    let success:Bool
    let userMessage: String
    let developerMessage: String
}

struct DictWrapper<T: Decodable> : Decodable {
    let data:T
    let success:Bool
    let userMessage: String
    let developerMessage: String
}
