//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Irina Deeva on 12/03/24.
//

import UIKit

final class TrackersViewController: UIViewController {
    private var trackerCollection: UICollectionView!
    private var datePicker: UIDatePicker!
    private var imageStub: UIImageView!
    private var labelStub: UILabel!

    var categories: [TrackerCategory] = [trackersHabits, trackersEvents]
    var completedTrackers: Set<TrackerRecord> = []
    //    var currentDate: Date = Date()
    //для хранения текущей даты в TrackersViewController добавлено свойство var currentDate: Date. Выбор даты в UIDatePicker меняет значение этого свойства, в результате показываются только те трекеры, у которых в расписании выбран день, совпадающий с датой в currentDate;

    let params = GeometricParams(cellCount: 2,
                                 leftInset: 16,
                                 rightInset: 16,
                                 cellSpacing: 9)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite

        setUpLayout()
    }
}

extension TrackersViewController {
    private func setUpLayout() {
        setUpNavigationBar()
        setUpTrackerCollectionView()
        setUpStub()
        setupConstraints()
    }

    private func setUpTrackerCollectionView() {
        let layout = UICollectionViewFlowLayout()

        trackerCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        trackerCollection.delegate = self
        trackerCollection.dataSource = self

        trackerCollection.register(
            TrackerCell.self,
            forCellWithReuseIdentifier: TrackerCell.reuseIdentifier
        )

        trackerCollection.register(
            SupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SupplementaryView.supplementaryIdentifier
        )

        view.addSubview(trackerCollection)
    }

    private func setUpNavigationBar() {
        setUpDatePicker()

        if let navBar = navigationController?.navigationBar {
            let rightButton = UIBarButtonItem(customView: datePicker)
            let leftButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTracker))
            leftButton.tintColor = .ypBlackDay

            navBar.topItem?.rightBarButtonItem = rightButton
            navBar.topItem?.leftBarButtonItem = leftButton

            navBar.prefersLargeTitles = true
            navBar.topItem?.title = "Трекеры"
        }

        setUpSearchBar()
    }

    private func setUpSearchBar() {
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchBar
    }

    @objc
    private func addTracker() {
    }

    private func setUpDatePicker() {
        datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(
            self,
            action: #selector(datePickerValueChanged(_:)),
            for: .valueChanged
        )
    }

    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yy"
        let formattedDate = dateFormater.string(from: selectedDate)
        print("Selected date: \(formattedDate)")
    }

    private func setUpStub() {
        imageStub = UIImageView()
        imageStub.image = UIImage(named: "emptyTracker") ?? UIImage()

        labelStub = UILabel()
        labelStub.text = "Что будем отслеживать?"
        labelStub.font = .systemFont(ofSize: 12)

        view.addSubview(imageStub)
        view.addSubview(labelStub)
    }

    private func setupConstraints() {
        trackerCollection.translatesAutoresizingMaskIntoConstraints = false
        labelStub.translatesAutoresizingMaskIntoConstraints = false
        imageStub.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            trackerCollection.topAnchor.constraint(equalTo: view.topAnchor),
            trackerCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trackerCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackerCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageStub.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageStub.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            labelStub.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            labelStub.topAnchor.constraint(equalTo: imageStub.bottomAnchor, constant: 8)
        ])

    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let trackerCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }

        trackerCell.prepareForReuse()

        trackerCell.emojiLabel.text = categories[indexPath.section].trackers[indexPath.row].emoji
        trackerCell.titleLabel.text = categories[indexPath.section].trackers[indexPath.row].name
        trackerCell.rectangleView.backgroundColor = categories[indexPath.section].trackers[indexPath.row].color
        trackerCell.addButton.backgroundColor = categories[indexPath.section].trackers[indexPath.row].color

        return trackerCell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        case UICollectionView.elementKindSectionHeader:
            id = "footer"
        default:
            id = ""
        }

        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: id,
            for: indexPath
        ) as? SupplementaryView else {
            return UICollectionReusableView()
        }

        view.titleLabel.text = categories[indexPath.section].title
        return view
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)

        return headerView.systemLayoutSizeFitting(
            CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - params.paddingWidth
        let cellWidth =  availableWidth / CGFloat(params.cellCount)

        return CGSize(width: cellWidth,
                      height: cellWidth * 0.88)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: params.leftInset, bottom: 0, right: params.rightInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return params.cellSpacing
    }
}
