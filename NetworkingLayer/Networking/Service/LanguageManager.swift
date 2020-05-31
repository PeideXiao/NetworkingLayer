//
//  LanguageManager.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/31/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

class LanguageManager: NSObject {
    
    static let shared = LanguageManager();
    
    func getLanguages(completion:@escaping ([Language]?, Error?) ->Void) {
        
        let route = HTTPNetworkRoute<LanguageAPI>()
        
        route.request(LanguageAPI.getLanguage) { (data: Data?, error: Error?) in
            if let data = data {
                do {
                    let languages =  try JSONDecoder().decode(ArrayWrapper<Language>.self, from: data)
                    completion(languages.data, nil)
                    
                } catch {
                    completion(nil, error)
                }
            }
            else {
                completion(nil, error)
            }
        }
    }
}
