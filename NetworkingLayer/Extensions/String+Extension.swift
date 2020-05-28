//
//  String+Extension.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/26/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    //MARK: - Localized
    func localized()-> String {
        return NSLocalizedString(self, comment: "");
    }
    
    // Counting words in a string
    var wordCount: Int {
        let regex = try? NSRegularExpression(pattern: "\\w+")
        return regex?.numberOfMatches(in: self, range: NSRange(location: 0, length: self.utf16.count)) ?? 0
    }
    
    // MARK: - Subscript
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start..<end]
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex...end]
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex..<end]
    }
    
    
    // MARK: -
    
    var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
    }
    
    var containsOnlyLetters: Bool {
        let notLetters = NSCharacterSet.letters.inverted
        return rangeOfCharacter(from: notLetters, options: String.CompareOptions.literal, range: nil) == nil
    }
    
    var isAlphanumeric: Bool {
        let notAlphanumeric = NSCharacterSet.decimalDigits.union(NSCharacterSet.letters).inverted
        return rangeOfCharacter(from: notAlphanumeric, options: String.CompareOptions.literal, range: nil) == nil
    }
    
    
    // MARK: - Validitoin
    
    var isValidEmail: Bool {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

          let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
          return emailTest.evaluate(with: self)
      }
    

    func pasterString(string: String) {
        
        let pasterBoard = UIPasteboard.general
        pasterBoard.string = string
    }
    
     
    // MARK: - Calculator width and height of string
    
    // Height
    func caculateStringWidth(string: String, maxWidth:CGFloat, fontSize: CGFloat) -> CGSize{
        
        var expectedLabelSize = CGSize.zero
        let attributes:[NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
        ]
        
        let maxSize = CGSize(width: Double(maxWidth), height: Double(MAXFLOAT));
        expectedLabelSize = (self as NSString).boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil).size;
        
        return expectedLabelSize;
    }
    
    
    
}
