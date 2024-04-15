//
//  CategoriesViewModal.swift
//  Tracker
//
//  Created by Irina Deeva on 14/04/24.
//

import Foundation

final class CategoriesViewModal {
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

    func getCategories() -> [TrackerCategory] {
        categories
    }
}

extension CategoriesViewModal: TrackerCategoryStoreDelegate {
    func storeCategory() {
        categories = trackerCategoryStore.categories
    }
}
