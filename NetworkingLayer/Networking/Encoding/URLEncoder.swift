//
//  URLEncoder.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/12/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

public struct URLEncoder {
    
    static func encodeURLParameters(for urlRequest: inout URLRequest, with parameters: HTTPParameters) throws {
        guard let url = urlRequest.url else { throw HTTPNetworkError.missingURL }
        
        if (parameters == nil) { return }
        guard let parameters = parameters else { throw HTTPNetworkError.parametersNil }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url;
        }
        
    }
    
    static func encodeBodyParameters(for request: inout URLRequest, with parameters: HTTPParameters) throws {
        guard let parameters = parameters else { throw HTTPNetworkError.parametersNil }
        let data = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.fragmentsAllowed);
        request.httpBody = data;
    }
    
    static func setHeaders(for urlRequest: inout URLRequest, with headers: HTTPHeaders) throws {
        for (key, value) in headers! {
            urlRequest.setValue("\(value)", forHTTPHeaderField: key);
        }
    }
}

