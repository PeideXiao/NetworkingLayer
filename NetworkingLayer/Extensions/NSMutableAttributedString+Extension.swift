//
//  NSAttributedString+Extension.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/26/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
     func attriString(target: String, fontSize: CGFloat? = nil, forgroundColor: UIColor? = nil, backgroundColor: UIColor? = nil) -> NSAttributedString {
        
        var attributes:[NSAttributedString.Key: Any] = [:];
        
        if let fontSize = fontSize {
            attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: fontSize);
        }
        if let forgroundColor = forgroundColor {
            attributes[NSAttributedString.Key.foregroundColor] = forgroundColor
        }
        if let backgroundColor = backgroundColor {
            attributes[NSAttributedString.Key.backgroundColor] = backgroundColor
        }
        self.addAttributes(attributes, range: self.rangeForTargetString(target: target));
        
        return self as NSAttributedString
    }
    
    func rangeForTargetString(target: String) -> NSRange {
        if let original = self.mutableString.copy() as? NSMutableString {
            return original.range(of: target);
        }
        else {
            return NSMakeRange(0, 0);
        }
    }
}
