//
//  Date+Ext.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 03. 21..
//

import Foundation

extension Date {
    
//    func convertDateToMonthYearFormat() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM yyyy"
//        return dateFormatter.string(from: self)
//    }

    func convertToDayMonthYearFormat() -> String {
        return formatted(.dateTime.day().month().year())
    }
    
    
}
