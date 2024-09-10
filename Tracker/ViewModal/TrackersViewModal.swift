//
//  CategoriesViewModal.swift
//  Tracker
//
//  Created by Irina Deeva on 14/04/24.
//

import Foundation

final class TrackersViewModal {
    private let trackerCategoryStore = TrackerCategoryStore()

    private var categories: [TrackerCategory] = [] {
        didSet {
            categoriesBinding?(self.categories)
        }
    }

    var categoriesBinding: Binding<[TrackerCategory]>?

    init() {
        trackerCategoryStore.delegate = self
        categories = trackerCategoryStore.categories
    }

    func addNewTrackerToTrackerCategory(_ tracker: Tracker, with categoryTitle: String) {
        try? trackerCategoryStore.addNew(tracker, to: categoryTitle)
        storeCategory()
    }

    func deleteTrackerFromTrackerCategory(_ tracker: Tracker) {
        try? trackerCategoryStore.deleteTrackerFromTrackerCategory(tracker)
    }

    func editTrackerAtTrackerCategory(_ tracker: Tracker) {
        try? trackerCategoryStore.editTrackerAtTrackerCategory(tracker)
        storeCategory()
    }

    func changeTrackerCategory(with categoryTitle: String, for tracker: Tracker) {
        try? trackerCategoryStore.changeTrackerCategory(with: categoryTitle, for: tracker)
        storeCategory()
    }

    func changeTrackerIsPinned(_ tracker: Tracker) {
        trackerCategoryStore.updateIsPinFor(tracker)
        storeCategory()
    }

    func getCategories() -> [TrackerCategory] {
        categories
    }
}

extension TrackersViewModal: TrackerCategoryStoreDelegate {
    func storeCategory() {
        categories = trackerCategoryStore.categories
    }
}
