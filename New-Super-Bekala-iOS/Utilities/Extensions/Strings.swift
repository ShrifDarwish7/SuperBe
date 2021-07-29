//
//  Strings.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 28/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

extension String{
    
    var localized: String{
        return NSLocalizedString(self, comment: "")
    }
    
    public var arToEnDigits : String? {
        var str = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    
    var fileExtension: String? {
        
        get{
            let url = self.suffix(6)
            guard url.firstIndex(of: ".") != nil else{ return nil }
            let ext = url[url.firstIndex(of: ".")!...]
            return String(ext).lowercased()
        }
        
    }
    
    public func firstIndex(char: Character) -> Int? {
        if let idx = self.firstIndex(of: char) {
            return self.distance(from: self.startIndex, to: idx)
        }
        return nil
    }
    
    func getTimeAgo()-> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: self)!
        
        let secondsAgo = Int(Date().timeIntervalSince(date))
        
        let minutes = 60
        let hour = 60 * minutes
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        if secondsAgo < minutes{
            return "lang".localized == "en" ? "\(secondsAgo)" + " seconds ago" : "منذ \(secondsAgo) ثانية"
        }else if secondsAgo < hour{
            return "lang".localized == "en" ? "\(secondsAgo / minutes)" + " minutes ago" : "منذ \(secondsAgo / minutes) دقيقة"
        }else if secondsAgo < day{
            return "lang".localized == "en" ? "\(secondsAgo / hour)" + " hours ago" : "منذ \(secondsAgo / hour) ساعة"
        }else if secondsAgo < week{
            return "lang".localized == "en" ? "\(secondsAgo / day)" + " days ago" : "منذ \(secondsAgo / day) ايام"
        }else if secondsAgo < month{
            return "lang".localized == "en" ? "\(secondsAgo / week)" + " weeks ago" : "منذ \(secondsAgo / week) اسابيع"
        }else if secondsAgo < year{
            return "lang".localized == "en" ? "\(secondsAgo / month)" + " months ago" : "منذ \(secondsAgo / month) شهور"
        }
        
        return "lang".localized == "en" ? "\(secondsAgo / year)" + " years ago" : "منذ \(secondsAgo / year) سنة"
    }
}
