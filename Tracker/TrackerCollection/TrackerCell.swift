//
//  TrackerCell.swift
//  Tracker
//
//  Created by Irina Deeva on 15/03/24.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    var emojiLabel: UILabel!
    var titleLabel: UILabel!
    static let reuseIdentifier = "trackerCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        emojiLabel = UILabel()
        emojiLabel.font = .systemFont(ofSize: 16.0)
        emojiLabel.backgroundColor = .ypWhiteTransparent
        contentView.addSubview(emojiLabel)

        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .ypWhite
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
//            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
//            emojiLabel.heightAnchor.constraint(equalTo: emojiLabel.widthAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
