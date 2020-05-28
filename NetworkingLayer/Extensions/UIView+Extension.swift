//
//  UIView+Extension.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/26/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
     func blur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light);
        let blurEffectiew = UIVisualEffectView(effect: blurEffect);
        self.addSubview(blurEffectiew);
    }
    
}


extension UISearchBar {
    
    var textField: UITextField? {
        if #available(iOS 13.0, *) {
            return searchTextField;
        } else {
            for view:UIView in self.subviews[0].subviews {
                if let textField = view as? UITextField {
                    return textField
                }
            }
        }
        return nil;
    }
}


//extension Bundle {
//    func decode<T: Decodable>(_ type: T.Type, from filename: String) -> T {
//        guard let json = url(forResource: filename, withExtension: nil) else {
//            fatalError("Failed to locate \(filename) in app bundle.")
//        }
//
//        guard let jsonData = try? Data(contentsOf: json) else {
//            fatalError("Failed to load \(filename) from app bundle.")
//        }
//
//        let decoder = JSONDecoder()
//
//        guard let result = try? decoder.decode(T.self, from: jsonData) else {
//            fatalError("Failed to decode \(filename) from app bundle.")
//        }
//
//        return result
//    }
//}
