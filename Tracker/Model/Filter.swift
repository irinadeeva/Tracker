//
//  Filters.swift
//  Tracker
//
//  Created by Irina Deeva on 18/04/24.
//

import Foundation

enum Filter: String, CaseIterable, Codable {
    case all
    case today
    case completed
    case uncompleted

    static var allCases: [Filter] {
        return [.all, .today, .completed, .uncompleted]
    }

    static var allCasesRawValue: [Filter] {
        return [
            Filter.all,
            Filter.today,
            Filter.completed,
            Filter.uncompleted
        ]
    }

    var localizedString: String {
        switch self {
        case .all:
            return NSLocalizedString("filters.all", comment: "")
        case .today:
            return NSLocalizedString("filters.today", comment: "")
        case .completed:
            return NSLocalizedString("filters.completed", comment: "")
        case .uncompleted:
            return NSLocalizedString("filters.uncompleted", comment: "")
        }
    }
}
