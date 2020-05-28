//
//  UIColor+Extension.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/26/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    var toHex: String? {
        return toHex()
    }
    
    // MARK: - Initialization
    convenience init?(hex: String){
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "0x")
        
        var rgb: UInt64 = 0
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil}
        
        if(length == 6) {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        }
        else if (length == 8) {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a);
    }
    
    
    func toHex(alpha: Bool = false) -> String? {
                
        guard let componets = cgColor.components, componets.count >= 3 else { return nil }
        let r = Float(componets[0])
        let g = Float(componets[1])
        let b = Float(componets[2])
        var a = Float(1.0)
        if (componets.count >= 4) {
            a = Float(componets[3])
        }
        
        if (alpha) {
                //        % defines the format specifier
                //        02 defines the length of the string
                //        l casts the value to an unsigned long
                //        X prints the value in hexadecimal (0-9 and A-F)
            return String(format: "%02lX%02lX%02lX%02lX", llroundf(r * 255), llroundf(g * 255), llroundf(b * 255), llroundf(a * 255));
        } else {
            return String(format: "%02lX%02lX%02lX", llroundf(r * 255), llroundf(g * 255), llroundf(b * 255));
        }
        
    }
    
    static func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256))/255.0
        let g = CGFloat(arc4random_uniform(256))/255.0
        let b = CGFloat(arc4random_uniform(256))/255.0
        let a = CGFloat(arc4random_uniform(256))/255.0
        return self.init(red: r, green: g, blue: b, alpha: a)
    }
}
