//
//  StubData.swift
//  Tracker
//
//  Created by Irina Deeva on 25/03/24.
//

import Foundation

let tracker1 = Tracker(id: UUID(), name: "Кошка, заслонила камеру на созвоне", color: .ypSelection2, emoji: "😻", timetable: [.monday, .tuesday])

let tracker2 = Tracker(id: UUID(), name: "Бабушка прислала открытку в вотсапе", color: .ypSelection1, emoji: "🌺", timetable: [.wednesday, .friday])

let tracker3 = Tracker(id: UUID(), name: "Свидания в апреле", color: .ypSelection14, emoji: "❤️", timetable: [.saturday, .sunday])

let tracker4 = Tracker(id: UUID(), name: "Поливать растения", color: .ypSelection5, emoji: "❤️", timetable: [.friday, .saturday, .wednesday])

let trackersHabits = TrackerCategory(title: "Домашний уют", trackers: [tracker4])

let trackersEvents = TrackerCategory(title: "Радостные мелочи", trackers: [tracker1, tracker2, tracker3])
