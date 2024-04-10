//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Irina Deeva on 06/04/24.
//

import CoreData
import UIKit


final class TrackerRecordStore: NSObject {
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>!
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

        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.completedTracker , ascending: true)
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

    var trackerRecords: Set<TrackerRecord> {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let records = try? objects.map({ try self.trackerRecord(from: $0) })
        else { return Set() }
        return Set(records)
    }

    func trackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = trackerRecordCoreData.completedTracker?.id,
              let date = trackerRecordCoreData.completedTrackerDate
        else { fatalError() }
        return TrackerRecord(completedTrackerId: id, completedTrackerDate: date)
    }

    func addNewTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerCoreData = trackerStore.predicateFetchById(trackerRecord.completedTrackerId)

        if let trackerCoreData {
            let trackerRecordCoreData = TrackerRecordCoreData(context: context)
            trackerRecordCoreData.completedTrackerDate = trackerRecord.completedTrackerDate
            trackerRecordCoreData.completedTracker = trackerCoreData

            do {
                print(trackerRecordCoreData)
                try context.save()
            } catch let error as NSError {
                print("Ошибка при сохранении: \(error), \(error.userInfo)")
                context.rollback()
            }
        }
    }

    func deleteTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "completedTrackerDate == %@",                                             trackerRecord.completedTrackerDate as CVarArg
        )

        do {
            let records = try context.fetch(fetchRequest)
            for record in records {
                if record.completedTracker?.id == trackerRecord.completedTrackerId {
//                    print(record)
                    context.delete(record)
                }
            }
            try context.save()
        } catch {
            print("Failed to delete tracker record: \(error.localizedDescription)")
        }
    }

    func deleteAllTrackerRecords() {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            for record in results {
                context.delete(record)
            }

            do {
                try context.save()
            } catch let error as NSError {
                print("Ошибка при сохранении: \(error), \(error.userInfo)")
                context.rollback()
            }
        } catch {
            print("Ошибка при выполнении запроса: \(error.localizedDescription)")
        }
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
}
