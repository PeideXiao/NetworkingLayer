//
//  HTTPNetworkResponse.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/12/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

enum Result {
    case success
    case failure(Error)
}

struct HTTPNetworkResponse {
    
    static func handleNetworkResponse(for response: HTTPURLResponse?) -> Result {
        guard let response = response else { return Result.failure(HTTPNetworkError.UnwrappingError) }
        
        switch response.statusCode {
        case 200...299: return .success
        case 401: return Result.failure(HTTPNetworkError.authenticationError)
        case 400...499: return Result.failure(HTTPNetworkError.badRequest)
        case 500...599: return Result.failure(HTTPNetworkError.serverSideError)
        default: return Result.failure(HTTPNetworkError.failed)
        }
    }
}
