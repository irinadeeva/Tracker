//
//  TrackerStore.swift
//  Tracker
//
//  Created by Irina Deeva on 06/04/24.
//
import CoreData
import UIKit

enum TrackerStoreError: Error {
    case decodingErrorInvalidId
    case decodingErrorInvalidName
    case decodingErrorInvalidColor
    case decodingErrorInvalidEmoji
    case decodingErrorInvalidTimetable
}

final class TrackerStore {
    private let context: NSManagedObjectContext
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            self.init()
            return
        }
        
        let context = appDelegate.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addNewTracker(_ tracker: Tracker, with category: TrackerCategoryCoreData) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color as NSObject
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.timetable = tracker.timetable as NSObject
        trackerCoreData.category = category
        
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }

    func deleteTracker(_ tracker: Tracker) throws {
        guard let tracker = predicateFetchById(tracker.id) else { return }

        context.delete(tracker)

        try? context.save()
    }

    func fetchTrackers() throws -> [Tracker] {
        let fetchRequest = TrackerCoreData.fetchRequest()
        let trackerFromCoreData = try context.fetch(fetchRequest)
        return try trackerFromCoreData.map { try self.tracker(from: $0) }
    }
    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        guard let name = trackerCoreData.name else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        guard let color = trackerCoreData.color as? UIColor else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        guard let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        guard let timetable = trackerCoreData.timetable as? [WeekDay] else {
            throw TrackerStoreError.decodingErrorInvalidId
        }
        
        return Tracker(id: id, name: name, color: color, emoji: emoji, timetable: timetable)
    }
    
    func predicateFetchById(_ trackerId: UUID) -> TrackerCoreData? {
        let request = TrackerCoreData.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "id == %@", trackerId.uuidString)
        request.fetchLimit = 1
        
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            return nil
        }
    }
}
