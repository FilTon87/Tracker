//
//  TrackerStore.swift
//  Tracker
//
//  Created by Anton Filipchuk on 07.04.2024.
//

import UIKit
import CoreData

private enum TrackerStoreError: Error {
    case decodingErrorInvalidTracker
    case decodingErrorInvalidTrackerID
}

final class TrackerStore {
    static let shared = TrackerStore()
    
    private let context: NSManagedObjectContext
    private let colorMarshalling = UIColorMarhalling()
    private let converSchedule = ConvertSchedule()
    private let categoryStore = TrackerCategoryStore.shared
    
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

extension TrackerStore {
    func addNewTracker(_ tracker: Tracker,_ category: String) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        let trackerCategory = categoryStore.fetchCategoryName(category)
        
        trackerCoreData.id = tracker.id
        trackerCoreData.trackerName = tracker.trackerName
        trackerCoreData.trackerColor = colorMarshalling.hexString(tracker.trackerColor)
        trackerCoreData.trackerEmoji = tracker.trackerEmoji
        trackerCoreData.isHabit = tracker.isHabit
        trackerCoreData.isPinned = tracker.isPinned
        
        if let schedule = tracker.schedule {
            trackerCoreData.schedule = converSchedule.toInt32(schedule)
        }
        
        trackerCoreData.trackerCategory = trackerCategory
        
        try self.context.save()
    }
    
    func convertToTracker(_ trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id,
              let trackerName = trackerCoreData.trackerName,
              let trackerEmoji = trackerCoreData.trackerEmoji,
              let color = trackerCoreData.trackerColor else {
            throw TrackerStoreError.decodingErrorInvalidTracker
        }
        let isHabit = trackerCoreData.isHabit
        let isPinned = trackerCoreData.isPinned
        let trackerColor = colorMarshalling.color(color)
        let trackerSchedule = converSchedule.toWeekDays(trackerCoreData.schedule)
        
        return Tracker(
            id: id,
            trackerName: trackerName,
            trackerColor: trackerColor,
            trackerEmoji: trackerEmoji,
            schedule: trackerSchedule,
            isHabit: isHabit,
            isPinned: isPinned)
    }
    
    func delTracker(_ id: UUID) throws {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K == %@", (\TrackerCoreData.id)._kvcKeyPathString!, id as CVarArg)
        
        if let result = try? context.fetch(request) {
            for object in result {
                context.delete(object)
            }
            do {
                try context.save()
            } catch {
                throw TrackerStoreError.decodingErrorInvalidTrackerID
            }
        }
    }
    
    func pinTracker(_ id: UUID) throws {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "%K == %@", (\TrackerCoreData.id)._kvcKeyPathString!, id as CVarArg)
        
        if let result = try? context.fetch(request) {
            for object in result {
                object.isPinned = !object.isPinned
            }
            do {
                try context.save()
            } catch {
                throw TrackerStoreError.decodingErrorInvalidTrackerID
            }
        }
    }
    
}
