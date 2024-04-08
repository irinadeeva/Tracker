//
//  EmojiMixCollectionViewCell.swift
//  Tracker
//
//  Created by Irina Deeva on 08/04/24.
//

import UIKit

final class EmojiMixCollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .ypBlackDay

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
