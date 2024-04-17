//
//  TrackerCell.swift
//  Tracker
//
//  Created by Irina Deeva on 15/03/24.
//

import UIKit

protocol TrackerCellButtonDelegate: AnyObject {
    func didTapButtonInCell(_ cell: TrackerCell)
    func didTapPinCell(_ cell: TrackerCell)
    func didTapEditCell(_ cell: TrackerCell)
    func didTapDeleteCell(_ cell: TrackerCell)
}

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

final class TrackerCell: UICollectionViewCell {
    static let reuseIdentifier = "trackerCell"

    var counterLabel: UILabel!
    var addButton: UIButton!
    var viewModel: TrackerCellViewModel! {
        didSet {
            trackerCardView.viewModel = viewModel
            trackerCardView.setUpView()
      }
    }

    private var trackerCardView: TrackerCardView!

    weak var delegate: TrackerCellButtonDelegate?
    private var isButtonSelected: Bool = false

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
        setupCounterLabel()
        setupAddButton()

        trackerCardView = TrackerCardView()
        trackerCardView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(trackerCardView)
        setupConstraints()
        setupContextMenu()
    }

    private func setupContextMenu() {
        let contextMenu = UIContextMenuInteraction(delegate: self)
        trackerCardView.isUserInteractionEnabled = true
        trackerCardView.addInteraction(contextMenu)
    }

    private func setupConstraints() {

        NSLayoutConstraint.activate([
            trackerCardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerCardView.heightAnchor.constraint(equalToConstant: 90),

            counterLabel.topAnchor.constraint(equalTo: trackerCardView.bottomAnchor, constant: 16),
            counterLabel.leadingAnchor.constraint(equalTo: trackerCardView.leadingAnchor, constant: 12),

            addButton.topAnchor.constraint(equalTo: trackerCardView.bottomAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: trackerCardView.trailingAnchor, constant: -12),
            addButton.widthAnchor.constraint(equalToConstant: 34),
            addButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    private func setupCounterLabel() {
        counterLabel = UILabel()
        counterLabel.font = .systemFont(ofSize: 12, weight: .medium)
        counterLabel.textColor = .ypBlackDay
        counterLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(counterLabel)
    }

    private func setupAddButton() {
        addButton = UIButton(type: .custom)
        addButton.layer.cornerRadius = 16
        addButton.layer.masksToBounds = true
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        addButton.imageView?.tintColor = .ypWhite
        addButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(addButton)
    }

    @objc private func addButtonPressed() {
        guard let delegate else { return }
        delegate.didTapButtonInCell(self)
    }
}

extension TrackerCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in

            let pin = UIAction(title: NSLocalizedString("contextMenu.pin", comment: "")) { _ in
                self.delegate?.didTapPinCell(self)
            }
            let edit = UIAction(title: NSLocalizedString("contextMenu.edit", comment: "")) { _ in
                self.delegate?.didTapEditCell(self)

            }
            let delete = UIAction(title: NSLocalizedString("contextMenu.delete", comment: ""), attributes: .destructive) { _ in
                self.delegate?.didTapDeleteCell(self)
            }

            return UIMenu(title: "", children: [pin, edit, delete])
        }
    }
}

final class TrackerCardView: UIView {
    var emojiLabel: UILabel!
    var titleLabel: UILabel!
    var viewModel: TrackerCellViewModel?
    var rectangleView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        backgroundColor = .clear
        setupRectangleView()
        setupTitleLabel()
        setupEmojiLabel()
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
        titleLabel.textColor = .ypWhite
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

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            rectangleView.topAnchor.constraint(equalTo: topAnchor),
            rectangleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rectangleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rectangleView.heightAnchor.constraint(equalToConstant: 90),

            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 30),
            emojiLabel.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }

    func setUpView() {
        titleLabel?.text = viewModel?.getTitleLabel()
        rectangleView?.backgroundColor = viewModel?.getViewColor()
        emojiLabel?.text = viewModel?.getEmojiLabel()
    }
}

