//
//  MovieServiceManager.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/13/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

class AlbumServiceManager: NSObject {

    static let shared = AlbumServiceManager()
    
    func getAlbums(_ searchItem: String, _ completion: @escaping(Result<[Album]>)-> Void) {
        let route = AlbumService.search(term: searchItem)
        
        do {
            try HTTPNetworkRequest.request(route) {(result: Result<Data>) in
                switch result {
                case .success(let data):
                    if let albums = try? self.decode(data) {
                        completion(Result.success(albums))
                    } else { completion(Result.failure(HTTPNetworkError.decodingFailed)) }
                case .failure(let error): completion(Result.failure(error))
                }
            }
        } catch {
            print(error);
        }
    }
}

extension AlbumServiceManager: HTTPNetworkDecoder {
    typealias EndPoint = AlbumService
    
    func decode(_ data: Data) throws -> [Album] {
        if let result = try? JSONDecoder().decode(Wrapper<Album>.self, from: data) {
            return result.results;
        }
        else { throw HTTPNetworkError.decodingFailed }
        
    }
}
