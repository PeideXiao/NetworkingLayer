//
//  HTTPMethod.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/12/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum HTTPTask {
    case request
    case requestParametersAndHeaders(parameters: HTTPParameters, additionalHeaders: HTTPHeaders)
}
