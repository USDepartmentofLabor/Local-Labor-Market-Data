//
//  DateFormatter+Extension.swift
//  Local Labor Market Data
//
//  Created by Nidhi Chawla on 9/4/18.
//  Copyright © 2018 Nidhi Chawla. All rights reserved.
//

import Foundation


extension DateFormatter {
    class func shortMonthName(fromMonth name: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        
        dateFormatter.dateFormat = "MMMM"
        
        if let date = dateFormatter.date(from: name) {
            dateFormatter.dateFormat = "MMM"
            return dateFormatter.string(from: date)
        }
        
        return nil
    }
    
    class func quarter(fromMonth name: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        
        dateFormatter.dateFormat = "MMMM"
        
        if let date = dateFormatter.date(from: name) {
            let calendar = Calendar.current
            let month = calendar.component(.month, from: date)
            return (month-1)/3 + 1
        }
        
        return nil
    }
}
