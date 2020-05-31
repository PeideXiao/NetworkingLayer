//
//  LanguageService.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/31/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

enum LanguageAPI {
    case getLanguage
}


extension LanguageAPI: EndPointType {
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "GetLanguages/"
    }
  
    var task: HTTPTask {
        return .request
    }
    
    var headers: HTTPHeaders {
        return nil
    }

}

