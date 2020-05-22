//
//  HTTPNetworkRoute.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/12/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

protocol HTTPNetworkRoute {
    associatedtype ModelType: Decodable
    var path:String { get }
    var method:HTTPMethod { get }
    var headers:HTTPHeaders { get }
    var task:HTTPTask { get }
}


extension HTTPNetworkRoute {
    var baseURL:String {
        return "https://itunes.apple.com/"
    }
}

