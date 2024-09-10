//
//  TrackerCellView.swift
//  Tracker
//
//  Created by Irina Deeva on 17/04/24.
//

import UIKit

final class TrackerCardView: UIView {
    var viewModel: TrackerCellViewModel?
    
    private var emojiLabel: UILabel!
    private var titleLabel: UILabel!
    private var rectangleView: UIView!
    private var pinImage: UIImageView!
    private var isPinned: Bool?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpView() {
        if let viewModel {
            titleLabel?.text = viewModel.getTitleLabel()
            rectangleView?.backgroundColor = viewModel.getViewColor()
            emojiLabel?.text = viewModel.getEmojiLabel()
            isPinned = viewModel.getIsPinned()

            if let isPinned, isPinned {
                pinImage.isHidden = false
            } else {
                pinImage.isHidden = true
            }
        }
    }

    private func setupLayout() {
        backgroundColor = .clear
        layer.cornerRadius = 16
        layer.masksToBounds = true

        setupRectangleView()
        setupTitleLabel()
        setupEmojiLabel()
        setupPinImage()
        setupConstraints()
    }

    private func setupRectangleView() {
        rectangleView = UIView()
        rectangleView.layer.masksToBounds = true
        rectangleView.layer.cornerRadius = 16
        rectangleView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(rectangleView)
    }

    private func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .ypWhiteAny
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleLabel)
    }

    private func setupEmojiLabel() {
        emojiLabel = UILabel()
        emojiLabel.font = .systemFont(ofSize: 16.0)
        emojiLabel.textAlignment = .center
        emojiLabel.backgroundColor = .ypWhiteTransparent
        emojiLabel.layer.cornerRadius = 16
        emojiLabel.layer.masksToBounds = true
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(emojiLabel)
    }

    private func setupPinImage() {
        pinImage = UIImageView(image: UIImage(named: "ypPin"))
        pinImage.isHidden = true
        pinImage.translatesAutoresizingMaskIntoConstraints = false

        addSubview(pinImage)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            rectangleView.topAnchor.constraint(equalTo: topAnchor),
            rectangleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rectangleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rectangleView.heightAnchor.constraint(equalToConstant: 90),

            pinImage.widthAnchor.constraint(equalToConstant: 24),
            pinImage.heightAnchor.constraint(equalToConstant: 24),
            pinImage.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            pinImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),

            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 30),
            emojiLabel.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
}
