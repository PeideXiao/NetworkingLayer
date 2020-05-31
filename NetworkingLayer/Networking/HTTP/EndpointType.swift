//
//  EndpointType.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/31/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case development
    case qa
    case production
}

protocol EndPointType {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders { get }
}



extension EndPointType {
    
      var baseURL: URL {
         guard let url =  URL(string: "https://jadmin2.jeunesseglobaldev.com/api/") else { fatalError("baseURL could not be configured.") }
         return url
     }
}
