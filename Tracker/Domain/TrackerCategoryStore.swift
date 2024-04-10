//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Irina Deeva on 06/04/24.
//

import CoreData
import UIKit

enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
    case decodingErrorInvalidTrackers
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func storeCategory()
}

final class TrackerCategoryStore: NSObject {
    weak var delegate: TrackerCategoryStoreDelegate?

    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>!
    private let context: NSManagedObjectContext
    private var trackerStore = TrackerStore()

    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.init()
            return
        }

        let context = appDelegate.context
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()

        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        controller.delegate = self
        self.fetchedResultsController = controller
        do {
            try controller.performFetch()
        } catch let error as NSError {
            print("Ошибка: \(error), \(error.userInfo)")
        }
    }

    var categories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let categories = try? objects.map({ try self.trackerCategory(from: $0) })
        else { return [] }
        return categories
    }

    func addNewTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)

        trackerCategoryCoreData.title = trackerCategory.title

        do {
            try context.save()
        } catch let error as NSError {
            print("Ошибка при сохранении: \(error), \(error.userInfo)")
            context.rollback()
        }
    }

    func addNewTrackerToTrackerCategory(_ tracker: Tracker, with categoryTitle: String) throws{
        guard let trackerCategoryCoreData = predicateFetchByTitle(with: categoryTitle) else {
            return
        }

        do {
            try trackerStore.addNewTracker(tracker, with: trackerCategoryCoreData)
        } catch let error as NSError {
            print("Ошибка при сохранении: \(error), \(error.userInfo)")
        }
    }

    func fetchTrackerCategories() throws -> [TrackerCategory] {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        let trackerCategoryFromCoreData = try context.fetch(fetchRequest)
        return try trackerCategoryFromCoreData.map { try self.trackerCategory(from: $0) }
    }

    private func trackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }

        var trackers: [Tracker] = []
        let trackersCoreData = try? fetchTrackersInCategory(trackerCategoryCoreData)
        if let trackersCoreData {
            trackers = try trackersCoreData.map { try TrackerStore().tracker(from: $0) }
        }

        return TrackerCategory(title: title, trackers: trackers)
    }

    func predicateFetchByTitle(with title: String) -> TrackerCategoryCoreData? {
        let request = TrackerCategoryCoreData.fetchRequest()
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), title)
            request.fetchLimit = 1

            do {
                let results = try context.fetch(request)
                return results.first
            } catch {
                print("Error fetching data: \(error)")
                return nil
            }
    }

    func fetchTrackersInCategory(_ category: TrackerCategoryCoreData) throws -> [TrackerCoreData] {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "category == %@", category)

        do {
            let trackers = try context.fetch(fetchRequest)
            return trackers
        } catch {
            throw error
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeCategory()
    }
}
