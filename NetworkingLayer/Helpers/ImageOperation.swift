//
//  ImageOperation.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/20/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

enum CustomError:String, Error {
    case URLMissingError = "URL is missing"
    case DecodeError = "Decode failed"
}

class ImageOperation: Operation {
    
    var album: Album
    var completion :((_:UIImage?, _:Error?) -> Void) = { (arg1, arg2) in }
    
    init(album:Album, completion:@escaping ((_:UIImage?, _: Error?) -> Void)) {
        self.album = album
        self.completion = completion
        super.init()
    }
    
    
    override func main() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: album.coverURL) else {
            completion(nil, CustomError.URLMissingError)
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.completion(nil, error);
            }
            else {
                if let res = response as? HTTPURLResponse,
                    let data = data, (res.statusCode == 200) {
                    let image = UIImage(data: data);
                    print("downloaded image--\(res.url!.absoluteString)")
                    do {
                        try SandBoxHandler.saveFile(fileName:"\(self.album.collectionID).jpg", data: data);
                        print("saved to sandbox")
                    } catch {
                        print("fail-saved sandbox==\(error)")
                    }
                    
                    DispatchQueue.main.async {
                        self.completion(image, nil);
                    }
                }
            }
        }.resume();
    }
}
