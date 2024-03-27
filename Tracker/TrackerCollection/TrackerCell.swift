//
//  TrackerCell.swift
//  Tracker
//
//  Created by Irina Deeva on 15/03/24.
//

import UIKit

protocol TrackerCellButtonDelegate: AnyObject {
    func didTapButtonInCell(_ cell: TrackerCell)
}

final class TrackerCell: UICollectionViewCell {
    var emojiLabel: UILabel!
    var titleLabel: UILabel!
    var counterLabel: UILabel!
    var addButton: UIButton!
    var rectangleView: UIView!
    static let reuseIdentifier = "trackerCell"

    weak var delegate: TrackerCellButtonDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackerCell {
    private func setupLayout() {
        setupRectangleView()
        setupTitleLabel()
        setupEmojiLabel()
        setupCounterLabel()
        setupAddButton()

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([

            rectangleView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rectangleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rectangleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rectangleView.heightAnchor.constraint(equalToConstant: 90),

            emojiLabel.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: rectangleView.topAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 30),
            emojiLabel.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: rectangleView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: -12),

            counterLabel.topAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: 16),
            counterLabel.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor, constant: 12),

            addButton.topAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: rectangleView.trailingAnchor, constant: -12),
            addButton.widthAnchor.constraint(equalToConstant: 34),
            addButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    private func setupRectangleView() {
        rectangleView = UIView()
        rectangleView.layer.masksToBounds = true
        rectangleView.layer.cornerRadius = 16
        rectangleView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(rectangleView)
    }

    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .ypWhite
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
    }

    private func setupEmojiLabel() {
        emojiLabel = UILabel()
        emojiLabel.font = .systemFont(ofSize: 16.0)
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = .ypWhiteTransparent
        emojiLabel.layer.cornerRadius = 16
        emojiLabel.layer.masksToBounds = true
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(emojiLabel)
    }

    private func setupCounterLabel() {
        counterLabel = UILabel()
        counterLabel.text = "0 дней"
        counterLabel.font = .systemFont(ofSize: 12, weight: .medium)
        counterLabel.textColor = .ypBlackDay
        counterLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(counterLabel)
    }

    private func setupAddButton() {
        addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.imageView?.tintColor = .ypWhite
        addButton.layer.cornerRadius = 16
        addButton.layer.masksToBounds = true
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(addButton)
    }

    @objc private func addButtonPressed() {
        delegate?.didTapButtonInCell(self)
        print("add cell Button Pressed")
    }

}
