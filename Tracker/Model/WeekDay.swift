//
//  DayOfWeek.swift
//  Tracker
//
//  Created by Irina Deeva on 24/03/24.
//

enum WeekDay: String, CaseIterable {
    case sunday = "Воскресенье"
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"

    static var allCases: [WeekDay] {
        return [.sunday, .monday, .tuesday, .wednesday, .thursday, .friday, .saturday]
    }
}
