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
    var counterLabel: UILabel!
    var addButton: UIButton!
    var rectangleView: UIView!
    static let reuseIdentifier = "trackerCell"

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupRectangleView()
        setupTitleLabel()
        setupEmojiLabel()
        setupCounterLabel()
        setupAddButton()

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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        print("add cell Button Pressed")
    }
}


//class CustomCollectionViewCell: UICollectionViewCell {
//
//// Elements inside the green block
//let iconView = UIView()
//let iconImageView = UIImageView()
//let titleLabel = UILabel()
//let greenBlockView = UIView()
//
//// Elements outside the green block
//let dayLabel = UILabel()
//let addButton = UIButton()
//
//override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//    super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//    // Green block view setup
//    greenBlockView.backgroundColor = UIColor.systemGreen
//    greenBlockView.layer.cornerRadius = 15
//    contentView.addSubview(greenBlockView)
//
//    // Icon view setup inside the green block
//    iconView.backgroundColor = .red
//    iconView.layer.cornerRadius = 15 // Adjust to make it circular
//    greenBlockView.addSubview(iconView)
//
//    // Icon image setup inside the icon view
//    iconImageView.image = UIImage(systemName: "heart.fill")
//    iconImageView.tintColor = .white
//    iconImageView.contentMode = .center
//    iconView.addSubview(iconImageView)
//
//    // Title label setup inside the green block
//    titleLabel.text = "Поливать растения"
//    titleLabel.textColor = .white
//    titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
//    greenBlockView.addSubview(titleLabel)
//
//    // Day label setup outside the green block
//    dayLabel.text = "1 день"
//    dayLabel.textColor = .black
//    dayLabel.font = UIFont.systemFont(ofSize: 14)
//    contentView.addSubview(dayLabel)
//
//    // Add button setup outside the green block
//    addButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
//    addButton.tintColor = .systemGreen
//    contentView.addSubview(addButton)
//
//    setupConstraints()
//}
//
//required init?(coder aDecoder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//}
//
//private func setupConstraints() {
//    // Disabling auto resizing mask and enabling auto layout
//    greenBlockView.translatesAutoresizingMaskIntoConstraints = false
//    iconView.translatesAutoresizingMaskIntoConstraints = false
//    iconImageView.translatesAutoresizingMaskIntoConstraints = false
//    titleLabel.translatesAutoresizingMaskIntoConstraints = false
//    dayLabel.translatesAutoresizingMaskIntoConstraints = false
//    addButton.translatesAutoresizingMaskIntoConstraints = false
//
//    // Constraints for the green block view
//    NSLayoutConstraint.activate([
//        greenBlockView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//        greenBlockView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
//        greenBlockView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
//        greenBlockView.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -10)
//    ])
//
//    // Constraints for the icon view
//    NSLayoutConstraint.activate([
//        iconView.leadingAnchor.constraint(equalTo: greenBlockView.leadingAnchor, constant: 10),
//        iconView.centerYAnchor.constraint(equalTo: greenBlockView.centerYAnchor),
//        iconView.widthAnchor.constraint(equalToConstant: 30),
//        iconView.heightAnchor.constraint(equalToConstant: 30)
//    ])
//
//    // Constraints for the icon image view
//    NSLayoutConstraint.activate([
//        iconImageView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
//        iconImageView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
//        iconImageView.widthAnchor.constraint(equalToConstant: 20),
//        iconImageView.heightAnchor.constraint(equalToConstant: 20)
//    ])
//
//    // Constraints for the title label
//    NSLayoutConstraint.activate([
//        titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
//
//titleLabel.centerYAnchor.constraint(equalTo: greenBlockView.centerYAnchor),
//        titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: greenBlockView.trailingAnchor, constant: -10)
//    ])
//
//    // Constraints for the day label
//    NSLayoutConstraint.activate([
//        dayLabel.leadingAnchor.constraint(equalTo: greenBlockView.trailingAnchor, constant: 10),
//        dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
//        dayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
//    ])
//
//    // Constraints for the add button
//    NSLayoutConstraint.activate([
//        addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//        addButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//        addButton.widthAnchor.constraint(equalToConstant: 30),
//        addButton.heightAnchor.constraint(equalToConstant: 30)
//    ])
//}
//}
