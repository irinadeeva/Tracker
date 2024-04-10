//
//  TrackerViewController.swift
//  Tracker
//
//  Created by Irina Deeva on 12/03/24.
//

import UIKit

final class TrackersViewController: UIViewController {
    private let trackerCategoryStore = TrackerCategoryStore()
    private var trackerRecordStore = TrackerRecordStore()

    private var trackerCollection: UICollectionView!
    private var datePicker: UIDatePicker!
    private var searchController: UISearchController!

    private var categories: [TrackerCategory] = []
    private var filteredCategories: [TrackerCategory] = []

    private var completedTrackers: Set<TrackerRecord> = []

    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    private var isFiltering: Bool {
        searchController.isActive && !isSearchBarEmpty
    }

    private var currentDate: Date = Date().startOfDay

    private let params = GeometricParams(cellCount: 2,
                                         leftInset: 16,
                                         rightInset: 16,
                                         cellSpacing: 9)


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite

        categories = trackerCategoryStore.categories
        trackerCategoryStore.delegate = self

        completedTrackers = trackerRecordStore.trackerRecords

        setupLayout()

        filterContentForData()
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
        let addTrackerViewController = AddTrackerViewController()
        addTrackerViewController.delegate = self
        addTrackerViewController.modalPresentationStyle = .automatic
        present(addTrackerViewController, animated: true, completion: nil)
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
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        guard let date = Calendar.current.date(from: components) else { return }
        currentDate = date

        filterContentForData()
    }

    private func filterContentForData() {
        let dayNumber = Calendar.current.component(.weekday, from: currentDate)
        let currentWeekDate = WeekDay.allCases[dayNumber - 1]
        filteredCategories.removeAll()

        guard !categories.isEmpty else { return }

        for category in categories {
            let filteredTrackers = category.trackers.filter { tracker in
                tracker.timetable.contains(where: { $0 == currentWeekDate})
            }

            if !filteredTrackers.isEmpty {
                filteredCategories.append(TrackerCategory(title: category.title, trackers: filteredTrackers))
            }
        }

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
        } else {
            filterContentForData()
            if filteredCategories.isEmpty {
                collectionView.setEmptyMessage(message: "Что будем отслеживать?", image: "emptyTracker")
            } else {
                collectionView.restore()
            }
        }
        return filteredCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories[section].trackers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let trackerCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.reuseIdentifier,
            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }

        let tracker = filteredCategories[indexPath.section].trackers[indexPath.row]

        trackerCell.prepareForReuse()

        let counter = completedTrackers.filter {
            $0.completedTrackerId == tracker.id
        }.count

        let flag = completedTrackers.filter {
            let trackerDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: $0.completedTrackerDate)
            let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)

            return $0.completedTrackerId == tracker.id && trackerDateComponents == currentDateComponents
        }.isEmpty

        if flag {
            trackerCell.addButton.setImage(UIImage(systemName: "plus"), for: .normal)
            trackerCell.addButton.alpha = 1
        } else {
            trackerCell.addButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            trackerCell.addButton.alpha = 0.3
        }

        trackerCell.delegate = self
        trackerCell.counterLabel.text = "\(counter) дней"
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

        view.titleLabel.text = filteredCategories[indexPath.section].title
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

extension TrackersViewController: TrackerCellButtonDelegate {
    func didTapButtonInCell(_ cell: TrackerCell) {

        if Date().startOfDay >= currentDate {
            guard let indexPath = trackerCollection.indexPath(for: cell) else { return }

            let tracker = filteredCategories[indexPath.section].trackers[indexPath.row]
            let record = TrackerRecord(completedTrackerId: tracker.id, completedTrackerDate: currentDate)

            let flag = completedTrackers.filter {
                return $0.completedTrackerId == tracker.id && $0.completedTrackerDate == currentDate
            }.isEmpty

            if flag {
                do {
                    completedTrackers.insert(record)
                    try trackerRecordStore.addNewTrackerRecord(record)
                } catch let error as NSError {
                    print("Ошибка: \(error), \(error.userInfo)")
                }
            } else {
                do {
                    completedTrackers.remove(record)
                    try trackerRecordStore.deleteTrackerRecord(record)
                } catch let error as NSError {
                    print("Ошибка: \(error), \(error.userInfo)")
                }
            }
        }

        
        trackerCollection.reloadData()
    }
}

extension TrackersViewController: AddTrackerDelegate {
    func didAddTracker(_ tracker: Tracker) {
        let categoryName = "Новая категория"
        let newCategoryIndex = categories.firstIndex { $0.title ==  categoryName }

        if let newCategoryIndex = newCategoryIndex {
            do {
                try trackerCategoryStore.addNewTrackerToTrackerCategory(tracker, with: categoryName)
            } catch let error as NSError {
                print("Ошибка: \(error), \(error.userInfo)")
            }
        } else {
            // create a new category with a new Name
            do {
                try trackerCategoryStore.addNewTrackerCategory(TrackerCategory(title: "", trackers: []))
            } catch let error as NSError {
                print("Ошибка: \(error), \(error.userInfo)")
            }
        }
    }
}

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func storeCategory() {
        categories = trackerCategoryStore.categories
        trackerCollection.reloadData()
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
