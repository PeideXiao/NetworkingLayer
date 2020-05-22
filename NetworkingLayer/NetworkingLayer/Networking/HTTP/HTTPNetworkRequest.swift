//
//  HTTPNewworkRequest.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/12/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit
import Foundation

public typealias HTTPParameters  = [String:Any]?
public typealias HTTPHeaders = [String:Any]?
typealias HTTPResponseResult = (Result<Data>) -> Void


struct HTTPNetworkRequest {
    static let session = URLSession(configuration: .default);
    
    static func request<EndPoint: HTTPNetworkRoute>(_ route:EndPoint, _ completion: @escaping HTTPResponseResult) throws {
        do {
            let request = try configureHTTPRequest(from: route);
            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription);
                    completion(Result.failure(error));
                }
                
                if let response = response as? HTTPURLResponse,
                    let formatData = data {
                    let result =  HTTPNetworkResponse.handleNetworkResponse(for: response)
                    
                    switch result {
                    case .success:
                        completion(Result.success(formatData))
                    case .failure:
                        completion(Result.failure(HTTPNetworkError.decodingFailed));
                    }
                }
            }.resume();
        } catch {
            throw error
        }
    }
    
    static func configureHTTPRequest<EndPoint: HTTPNetworkRoute>(from route: EndPoint ) throws -> URLRequest {
        
        guard let url = URL(string: route.baseURL.appending(route.path)) else { throw HTTPNetworkError.missingURL }
        var request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10.0);
        
        request.httpMethod = route.method.rawValue
        
        do  {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParametersAndHeaders(let urlParameters, let additionalHeaders):
                try configureParametersAndHeader(parameters:urlParameters,  headers: additionalHeaders, request: &request)
            }
            
            return request
            
        } catch {
            throw error
        }
    }
    
    static func configureParametersAndHeader(parameters:HTTPParameters, headers:HTTPHeaders, request: inout URLRequest) throws {
        
        do {
            guard let method = request.httpMethod else { throw HTTPNetworkError.missingURL }
            switch method {
            case "GET": try URLEncoder.encodeURLParameters(for: &request, with: parameters)
            case "POST": try URLEncoder.encodeBodyParameters(for: &request, with: parameters)
            default:
                break
            }
            if let headers = headers { try URLEncoder.setHeaders(for: &request, with: headers) }
        } catch {
            throw HTTPNetworkError.encodingFailed
        }
    }
}


protocol HTTPNetworkDecoder {
    
    associatedtype EndPoint: HTTPNetworkRoute
    
    func decode(_ data: Data) throws -> [EndPoint.ModelType] 
}
