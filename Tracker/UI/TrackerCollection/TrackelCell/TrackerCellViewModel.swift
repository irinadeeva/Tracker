//
//  TrackerCellViewModel.swift
//  Tracker
//
//  Created by Irina Deeva on 17/04/24.
//

import UIKit

final class TrackerCellViewModel {
    private let emojiLabel: String
    private let titleLabel: String
    private let viewColor: UIColor

    init(emojiLabel: String, titleLabel: String, viewColor: UIColor) {
        self.emojiLabel = emojiLabel
        self.titleLabel = titleLabel
        self.viewColor = viewColor
    }

    func getEmojiLabel() -> String {
        return emojiLabel
    }

    func getTitleLabel() -> String {
        return titleLabel
    }

    func getViewColor() -> UIColor {
        return viewColor
    }
}
