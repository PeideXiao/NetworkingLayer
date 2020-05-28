//
//  SandBoxHandler.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/21/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

class SandBoxHandler: NSObject {
    
    static let shared:SandBoxHandler = SandBoxHandler()
    
    static func saveFile(fileName: String, data: Data) throws {
        try data.write(to: self.filePath(fileName: fileName), options:[])
    }
    
    
    static func readData(from fileName: String) throws -> Data {
        return try Data(contentsOf: self.filePath(fileName: fileName))
    }
    
    
    static func filePath(fileName: String) -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName, isDirectory: false);
    }
    
    
    //******************************************************************************************
    // MARK: - Cache
    //******************************************************************************************
    
    
    static func saveFileToCache(fileName: String, data: Data) throws {
        try data.write(to: self.cacheFilePath(fileName: fileName), options:[])
    }
    
    
    static func readCacheData(from fileName: String) throws -> Data {
        return try Data(contentsOf: self.cacheFilePath(fileName: fileName))
    }
    
    
    static func cacheFilePath(fileName: String) -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent(fileName, isDirectory: false);
    }
    
}
