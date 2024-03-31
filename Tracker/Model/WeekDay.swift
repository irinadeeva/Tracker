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
        return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    }

    static var allCasesRawValue: [String] {
        return allCases.map { $0.rawValue }
    }
}
