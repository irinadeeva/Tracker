//
//  DayOfWeek.swift
//  Tracker
//
//  Created by Irina Deeva on 24/03/24.
//

enum WeekDay: String, CaseIterable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"

    static var allCases: [WeekDay] {
        return [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
    }

    static var allCasesRawValue: [String] {
        return [
            WeekDay.monday.rawValue,
            WeekDay.tuesday.rawValue,
            WeekDay.wednesday.rawValue,
            WeekDay.thursday.rawValue,
            WeekDay.friday.rawValue,
            WeekDay.saturday.rawValue,
            WeekDay.sunday.rawValue
        ]
    }
}
