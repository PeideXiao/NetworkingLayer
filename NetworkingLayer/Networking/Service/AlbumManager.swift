//
//  MovieServiceManager.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/13/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

class AlbumManager: NSObject {
    static let environment: NetworkEnvironment = .development
    static let shared = AlbumManager()
    
    
    func getAlbums(searchItem: String, completion:@escaping ([Album]?, Error?) -> Void) {
        
        let service = AlbumAPI.search(term: searchItem)
        let route = HTTPNetworkRoute<AlbumAPI>();
        
        route.request(service) { (data, error) in
            if let err = error {
                completion(nil, err)
                return
            }
            
            if let data = data {
                do {
                    let albums =  try JSONDecoder().decode(Wrapper<Album>.self, from: data)
                    completion(albums.data, nil)
                    
                } catch {
                    completion(nil, error)
                }
            }
        }
    }
}
