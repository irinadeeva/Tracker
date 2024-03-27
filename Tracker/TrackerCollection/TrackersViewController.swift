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
    private var searchController: UISearchController!

    private var categories: [TrackerCategory] =
//    []
    [trackersHabits, trackersEvents]
    private var completedTrackers: Set<TrackerRecord> = []

    private var filteredCategories: [TrackerCategory] = []
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    private var isSearchingByDate: Bool = false

    private var isFiltering: Bool {
        searchController.isActive && !isSearchBarEmpty || isSearchingByDate
    }

    private var currentWeekDate: WeekDay = .monday

    private let params = GeometricParams(cellCount: 2,
                                 leftInset: 16,
                                 rightInset: 16,
                                 cellSpacing: 9)

    var daysOfTheWeek: [String] {
         return  ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite

        setupLayout()
    }
}

extension TrackersViewController {
    private func setupLayout() {
        setupNavigationBar()
        setupTrackerCollectionView()
    }

    private func setupTrackerCollectionView() {
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

        trackerCollection.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            trackerCollection.topAnchor.constraint(equalTo: view.topAnchor),
            trackerCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trackerCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackerCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupNavigationBar() {
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
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchResultsUpdater = self

        navigationItem.searchController = searchController
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
        print(currentWeekDate)
        print(categories[0].trackers[0].timetable)
//        let selectedDate = sender.date
//        print("Selected date: \(selectedDate)")
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "dd.MM.yy"
//        let formattedDate = dateFormater.string(from: selectedDate)
//        print("Selected date: \(formattedDate)")
//        currentDate = selectedDate
        let dayNumber = Calendar.current.component(.weekday, from: sender.date)
        currentWeekDate = WeekDay.allCases[dayNumber - 1]
        print(currentWeekDate)
        filterContentForData()
    }

    private func filterContentForData() {
        isSearchingByDate = true
        filteredCategories.removeAll()

        guard !categories.isEmpty else { return }

        for category in categories {
            // Filter the trackers inside the category based on the name
            let filteredTrackers = category.trackers.filter { tracker in
                tracker.timetable.contains(where: { $0 == currentWeekDate})
            }

            // Only create a new TrackerCategory if there are filtered trackers available
            if !filteredTrackers.isEmpty {
                filteredCategories.append(TrackerCategory(title: category.title, trackers: filteredTrackers))
            }
        }

        print(filteredCategories)
        trackerCollection.reloadData()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isFiltering {
            if filteredCategories.isEmpty {
                collectionView.setEmptyMessage(message: "Ничего не найдено", image: "emptySearch")
            } else {
                collectionView.restore()
            }
            return filteredCategories.count
        } else {
            if categories.isEmpty {
                collectionView.setEmptyMessage(message: "Что будем отслеживать?", image: "emptyTracker")
            } else {
                collectionView.restore()
            }
            return categories.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCategories[section].trackers.count
        }

        return categories[section].trackers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let trackerCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }

        var tracker: Tracker
        if isFiltering {
            tracker = filteredCategories[indexPath.section].trackers[indexPath.row]
          } else {
            tracker = categories[indexPath.section].trackers[indexPath.row]
        }

        trackerCell.prepareForReuse()

        trackerCell.emojiLabel.text = tracker.emoji
        trackerCell.titleLabel.text = tracker.name
        trackerCell.rectangleView.backgroundColor = tracker.color
        trackerCell.addButton.backgroundColor = tracker.color

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

        var title: String
        if isFiltering {
            title = filteredCategories[indexPath.section].title
          } else {
            title = categories[indexPath.section].title
        }

        view.titleLabel.text = title
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

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text)
    }

    private func filterContentForSearchText(_ searchText: String?) {
        guard let searchText else { return }

        filteredCategories.removeAll()

        guard !categories.isEmpty else { return }

        for category in categories {
            let filteredTrackers = category.trackers.filter { tracker in
                tracker.name.lowercased().contains(searchText.lowercased())
            }

            if !filteredTrackers.isEmpty {
                filteredCategories.append(TrackerCategory(title: category.title, trackers: filteredTrackers))
            }
        }

        trackerCollection.reloadData()
    }
}

extension UICollectionView {
    func setEmptyMessage(message: String, image: String) {
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        emptyView.backgroundColor = .ypWhite
        emptyView.sizeToFit()

        let imageStub = UIImageView()
        imageStub.image = UIImage(named: image) ?? UIImage()
        emptyView.addSubview(imageStub)

        let labelStub = UILabel()
        labelStub.text = message
        labelStub.font = .systemFont(ofSize: 12, weight: .medium)
        labelStub.textColor = .ypBlackDay
        emptyView.addSubview(labelStub)

        imageStub.translatesAutoresizingMaskIntoConstraints = false
        labelStub.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageStub.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            imageStub.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            labelStub.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            labelStub.topAnchor.constraint(equalTo: imageStub.bottomAnchor, constant: 8)
        ])

        self.backgroundView = emptyView
    }

    func restore() {
        self.backgroundView = nil
    }
}
