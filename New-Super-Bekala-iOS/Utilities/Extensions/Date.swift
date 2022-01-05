//
//  Date.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 30/10/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

extension Date {

    static func -(recent: Date, previous: Date) -> DateComponents {
        return Calendar.current.dateComponents([.hour,.minute,.second], from: previous, to: recent)
    }
    
    func dateAt(hours: Int, minutes: Int) -> Date
      {
        let calendar = Calendar(identifier: Calendar.current.identifier)

        var date_components = calendar.dateComponents(
          [.year,
           .month,
           .day],
          from: self)

        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0

        let newDate = calendar.date(from: date_components)!
        return newDate
      }
    
    func checkIftarTime()-> Bool{
        let todaysDate  = Date()
        let iftarTimeStr = "5:00"
       // let endString   = "16:30"

        // convert strings to `Date` objects

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let startTime = formatter.date(from: iftarTimeStr)
        //let endTime = formatter.date(from: endString)

        // extract hour and minute from those `Date` objects

        let calendar = Calendar.current

        var startComponents = calendar.dateComponents([.hour, .minute], from: startTime!)
       // var endComponents = calendar.dateComponents([.hour, .minute], from: endTime!)

        // extract day, month, and year from `todaysDate`

        let nowComponents = calendar.dateComponents([.month, .day, .year], from: self)

        // adjust the components to use the same date

        startComponents.year  = nowComponents.year
        startComponents.month = nowComponents.month
        startComponents.day   = nowComponents.day
//
//        endComponents.year  = nowComponents.year
//        endComponents.month = nowComponents.month
//        endComponents.day   = nowComponents.day

        // combine hour/min from date strings with day/month/year of `todaysDate`

        guard
            let iftarDate = calendar.date(from: startComponents)
          //  let endDate = calendar.date(from: endComponents)
        else {
            print("unable to create dates")
            return false
        }

        // now we can see if today's date is inbetween these two resulting `NSDate` objects

        let isInRange = todaysDate < iftarDate
        return isInRange
    }

}
