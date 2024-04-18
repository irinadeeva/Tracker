//
//  DataExtention.swift
//  Tracker
//
//  Created by Irina Deeva on 18/04/24.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
