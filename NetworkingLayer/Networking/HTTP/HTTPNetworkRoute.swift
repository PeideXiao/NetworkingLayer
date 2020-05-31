//
//  HTTPNetworkRoute.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/12/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit


public typealias NetworkRouterCompletion = (_ data: Data?, _ error: Error?)->()


protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}


class HTTPNetworkRoute<EndPoint: EndPointType>: NetworkRouter {
    
    private var task: URLSessionTask?
    
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else{ return }
                
                let result = HTTPNetworkResponse.handleNetworkResponse(for: response)
                
                switch result {
                    case .success:
                        guard let data = data else {
                            completion(nil, HTTPNetworkError.noData)
                            return
                        }
                        completion(data, nil)
                    case .failure(let err):
                        completion(nil, err)
                }
            })
        }catch {
            completion(nil, error)
        }
        self.task?.resume()
    }
    
    
    func cancel() {
        self.task?.cancel()
    }
    
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
