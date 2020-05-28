//
//  DateHandler.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/26/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit



class DateHandler: NSObject {

   // Returns a String in SQL datetime Format from Date
       class func dateTimeString(date:Date) -> String {
           var dateString:String = "";
           
           let formatter:DateFormatter = DateFormatter();
           formatter.amSymbol = "AM";
           formatter.pmSymbol = "PM";
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ";
           formatter.timeZone = TimeZone(secondsFromGMT: 0);
           
           dateString = formatter.string(from: date);
           return dateString;
       }
    
    
    // Returns an Date object from datetime string
       class func date(datetimeString:String) -> Date {
           
           let formatter:DateFormatter = DateFormatter();
           formatter.amSymbol = "AM";
           formatter.pmSymbol = "PM";
           formatter.timeZone = TimeZone(secondsFromGMT: 0);
           
           // Attempt to Parse Date
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
           if let date = formatter.date(from: datetimeString) { return date; }
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ";
           if let date = formatter.date(from: datetimeString) { return date; }
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ";
           if let date = formatter.date(from: datetimeString) { return date; }
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss";
           if let date = formatter.date(from: datetimeString) { return date; }
           formatter.dateFormat = "MM/dd/yyyy";
           formatter.timeZone = TimeZone.autoupdatingCurrent;
           if let date = formatter.date(from: datetimeString) { return date; }
           formatter.dateFormat = "M/d/yy";
           formatter.timeZone = TimeZone.autoupdatingCurrent;
           if let date = formatter.date(from: datetimeString) { return date; }
           return Date();
       }
    
    
    // Returns a Localized Date String
    class func localeDateString(date:Date, dateStyle:DateFormatter.Style, timeStyle:DateFormatter.Style) -> String {
        var dateString:String = "";
        
        let locale:Locale = Locale.current;
        let formatter:DateFormatter = DateFormatter();
        formatter.amSymbol = "AM";
        formatter.pmSymbol = "PM";
        
        formatter.dateStyle = dateStyle;
        formatter.timeStyle = timeStyle;
        
        // Handle Localization
        formatter.locale = locale;
        formatter.timeZone = TimeZone.autoupdatingCurrent;
        
        dateString = formatter.string(from: date);
        
        return dateString;
    }
    
    
}
