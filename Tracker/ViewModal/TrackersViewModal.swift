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
        try? trackerCategoryStore.addNewTrackerToTrackerCategory(tracker, with: categoryTitle)
    }

    func deleteTrackerFromTrackerCategory(_ tracker: Tracker) {
        try? trackerCategoryStore.deleteTrackerFromTrackerCategory(tracker)
    }

    func editTrackerAtTrackerCategory(_ tracker: Tracker) {
        try? trackerCategoryStore.editTrackerAtTrackerCategory(tracker)
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
