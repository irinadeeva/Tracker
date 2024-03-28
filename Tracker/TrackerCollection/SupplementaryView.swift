//
//  SupplementaryView.swift
//  Tracker
//
//  Created by Irina Deeva on 25/03/24.
//

import UIKit

final class SupplementaryView: UICollectionReusableView {
    var titleLabel: UILabel!
    static let supplementaryIdentifier = "header"

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 19, weight: .bold)
        titleLabel.textColor = .ypBlackDay
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
