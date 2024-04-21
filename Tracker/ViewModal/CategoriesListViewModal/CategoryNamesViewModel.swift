//
//  CategoryNamesViewModel.swift
//  Tracker
//
//  Created by Irina Deeva on 15/04/24.
//

import Foundation

class CategoryNamesViewModel {
    var namesBinding: Binding<[CategoryNameViewModel]>?

    private let trackerCategoryStore = TrackerCategoryStore()

    private(set) var names: [CategoryNameViewModel] = [] {
        didSet {
            namesBinding?(self.names)
        }
    }

    private let selectedCategory: String

    init(selectedCategory: String) {
        self.selectedCategory = selectedCategory
        trackerCategoryStore.delegate = self
        names = trackerCategoryStore.categories.map{
            CategoryNameViewModel(
                name: $0.title
            )
        }
    }

    func addNewTrackerCategory(_ trackerCategoryName: String) {
        try? trackerCategoryStore.addNewTrackerCategory(trackerCategoryName)
    }

    func getSelectedCategory() -> String {
        return selectedCategory
    }
}

extension CategoryNamesViewModel: TrackerCategoryStoreDelegate {
    func storeCategory() {
        names = trackerCategoryStore.categories.map{
            CategoryNameViewModel(
                name: $0.title
            )
        }
    }
}
