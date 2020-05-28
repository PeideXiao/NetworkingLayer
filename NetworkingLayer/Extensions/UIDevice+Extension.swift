//
//  UIDevice+Extension.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/24/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    
   // get device's uuid
    static func UUID() -> String? {
        if let uuid =  self.current.identifierForVendor {
            return uuid.uuidString;
        }
        return nil;
    }
    
}
