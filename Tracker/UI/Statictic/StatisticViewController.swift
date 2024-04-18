//
//  File.swift
//  Tracker
//
//  Created by Irina Deeva on 12/03/24.
//
import UIKit

final class StatisticViewController: UIViewController {
    private var trackerRecordStore = TrackerRecordStore()

    private lazy var imageStub: UIImageView = {
        let imageStub = UIImageView()
        imageStub.image = UIImage(named: "emptyStatistic") ?? UIImage()
        return imageStub
    }()

    private lazy var labelStub: UILabel = {
        let labelStub = UILabel()
        labelStub.text = NSLocalizedString("emptyStatistic.title", comment: "")
        labelStub.font = .systemFont(ofSize: 12, weight: .medium)
        labelStub.textColor = .ypBlackDay
        labelStub.numberOfLines = 2
        labelStub.textAlignment = .center
        return labelStub
    }()

    private let statisticsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statistic.title", comment: "")
        label.font = .boldSystemFont(ofSize: 34)
        label.textColor = .ypBlackDay
        return label
    }()

    private lazy var completedTrackersCard = StatisticCardView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupStatistic()
    }
}

extension StatisticViewController {
    private func setupUI() {
        [statisticsLabel, completedTrackersCard, imageStub, labelStub].forEach { view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            statisticsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statisticsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),

            completedTrackersCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            completedTrackersCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            completedTrackersCard.topAnchor.constraint(equalTo: statisticsLabel.bottomAnchor, constant: 77),
            completedTrackersCard.heightAnchor.constraint(equalToConstant: 90),

            imageStub.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageStub.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            labelStub.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelStub.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelStub.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            labelStub.topAnchor.constraint(equalTo: imageStub.bottomAnchor, constant: 8)
        ])
    }

    private func setupStatistic() {
        guard let completedTrackers = trackerRecordStore.fetchAllTrackerRecords() else {
            return }

        if completedTrackers == 0 {
            completedTrackersCard.isHidden = true
            imageStub.isHidden = false
            labelStub.isHidden = false
        } else {
            completedTrackersCard.isHidden = false
            imageStub.isHidden = true
            labelStub.isHidden = true

            completedTrackersCard.updateView(counter: completedTrackers)
        }
    }
}
