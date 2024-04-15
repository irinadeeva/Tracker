//
//  CategoryNamesViewModel.swift
//  Tracker
//
//  Created by Irina Deeva on 15/04/24.
//

import Foundation

class CategoryNamesViewModel {
    private let trackerCategoryStore = TrackerCategoryStore()

    private(set) var names: [CategoryNameViewModel] = [] {
        didSet {
            namesBinding?(self.names)
        }
    }

    var namesBinding: Binding<[CategoryNameViewModel]>?

    init() {
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
