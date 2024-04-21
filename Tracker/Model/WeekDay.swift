//
//  DayOfWeek.swift
//  Tracker
//
//  Created by Irina Deeva on 24/03/24.
//
import UIKit

enum WeekDay: String, CaseIterable, Codable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    static var allCases: [WeekDay] {
        return [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
    }

    static var allCasesRawValue: [WeekDay] {
        return [
            WeekDay.monday,
            WeekDay.tuesday,
            WeekDay.wednesday,
            WeekDay.thursday,
            WeekDay.friday,
            WeekDay.saturday,
            WeekDay.sunday
        ]
    }

    var localizedString: String {
        switch self {
        case .monday:
            return NSLocalizedString("weekDay.Monday", comment: "")
        case .tuesday:
            return NSLocalizedString("weekDay.Tuesday", comment: "")
        case .wednesday:
            return NSLocalizedString("weekDay.Wednesday", comment: "")
        case .thursday:
            return NSLocalizedString("weekDay.Thursday", comment: "")
        case .friday:
            return NSLocalizedString("weekDay.Friday", comment: "")
        case .saturday:
            return NSLocalizedString("weekDay.Saturday", comment: "")
        case .sunday:
            return NSLocalizedString("weekDay.Sunday", comment: "")
        }
    }
}
