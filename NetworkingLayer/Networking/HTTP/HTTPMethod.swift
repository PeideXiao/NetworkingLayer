//
//  HTTPMethod.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/12/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

public typealias HTTPParameters  = [String:Any]?
public typealias HTTPHeaders = [String:String]?

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: HTTPParameters,
        bodyEncoding: ParameterEncoding,
        urlParameters: HTTPParameters)
    
    case requestParametersAndHeaders(bodyParameters: HTTPParameters,
        bodyEncoding: ParameterEncoding,
        urlParameters: HTTPParameters,
        additionHeaders: HTTPHeaders)
    
    // case download, upload...etc
}


