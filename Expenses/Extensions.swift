//
//  Extensions.swift
//  Expenses
//
//  Created by Laptop on 7/6/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

extension Int16 {
    var str02: String { return String(format: "%02d", self) }
    var str04: String { return String(format: "%04d", self) }
    var monthName: String { return ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"][Int(self)-1] }
}

extension NSDecimalNumber {
    var money: String {
        get {
            let formatter = NumberFormatter()
            formatter.usesGroupingSeparator = true
            formatter.numberStyle = NumberFormatter.Style.currency
            formatter.locale = NSLocale.current
            let value = formatter.string(from: self) ?? "$0.00"
            return value
        }
    }
    
    var str: String { return String(describing: self) }
}

extension Date {
    var day   : Int16 { return Int16(Calendar.current.component(.day,   from:self)) }
    var month : Int16 { return Int16(Calendar.current.component(.month, from:self)) }
    var year  : Int16 { return Int16(Calendar.current.component(.year,  from:self)) }
    var yymm  : String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMM"
            return dateFormatter.string(from: self)
        }
    }
}

extension String {
    var decimal: NSDecimalNumber {
        get {
            var amount = NSDecimalNumber(string: self)
            if amount == NSDecimalNumber.notANumber {
                amount = 0.0
            }
            return amount
        }
    }
    
    func or(_ def: String) -> String {
        if self.isEmpty { return def }
        return self
    }
    
}



// END
