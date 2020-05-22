//
//  MovieService.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/13/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

enum AlbumService {
    case recomment(id: Int)
    case newMovies(page: Int)
    case video(id: Int)
    case search(term: String)
}

extension AlbumService: HTTPNetworkRoute {
 
    var path: String {
        switch self {
        case .recomment(let id): return "\(id)/recommendations"
        case .newMovies(_): return "questions"
        case .video(let id): return "\(id)/(vidoe)"
        case .search(_): return "search"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var headers: HTTPHeaders {
        return nil
    }
    
    var task: HTTPTask {
        switch self {
        case .recomment:
            return .request
        case .newMovies(let page):
            let parameters: [String : Any]? = [
                           "site":"stackoverflow",
                           "tagged":"ios",
                           "sort":"votes",
                           "order":"desc",
                           "pagesize":"2",
                           "page":"\(page)"
                       ]
            return .requestParametersAndHeaders(parameters:parameters, additionalHeaders: nil)
            
        case .video(_):
            return .request
            
        case .search(let term):
            let parameters: [String : Any]? = [
                           "media":"music",
                           "entity":"song",
                           "term":"\(term)"
                       ]
            return .requestParametersAndHeaders(parameters:parameters, additionalHeaders: nil)
        }
    }
    
    
    typealias ModelType = Album
}
