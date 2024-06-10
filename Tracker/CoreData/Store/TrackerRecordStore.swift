//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Anton Filipchuk on 07.04.2024.
//

import UIKit
import CoreData

private enum TrackerRecordStoreError: Error {
    case decodingErrorInvalidTrackerID
    case decodingErrorInvalidDoneDate
}

final class TrackerRecordStore {
    private let context: NSManagedObjectContext
    static let shared = TrackerRecordStore()
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

extension TrackerRecordStore {
    func saveTrackerRecord(_ record: TrackerRecord) throws {
        let newRecord = TrackerRecordCoreData(context: context)
        newRecord.trackerDoneDate = record.trackerDoneDate
        newRecord.trackerID = record.trackerID
        try context.save()
    }
    
    func fetchTrackerRecord() throws -> [TrackerRecord] {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        let recordFromCoreData = try context.fetch(fetchRequest)
        return try recordFromCoreData.map { try self.convertToTrackerRecord(from: $0) }
    }
    
    private func convertToTrackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let trackerID = trackerRecordCoreData.trackerID else {
            throw TrackerRecordStoreError.decodingErrorInvalidTrackerID
        }
        guard let trackerDoneDate = trackerRecordCoreData.trackerDoneDate else {
            throw TrackerRecordStoreError.decodingErrorInvalidDoneDate
        }
        
        return TrackerRecord(
            trackerID: trackerID,
            trackerDoneDate: trackerDoneDate)
    }
    
    func delTrackerRecord(_ record: TrackerRecord) throws {
        let id = record.trackerID
        let startOfDay = Calendar.current.startOfDay(for: record.trackerDoneDate)
        var endOfDay: Date {
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return Calendar.current.date(byAdding: components, to: startOfDay)!
        }
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "(%K == %@) AND (%K BETWEEN {%@, %@})",
            #keyPath(TrackerRecordCoreData.trackerID), id as CVarArg,
            #keyPath(TrackerRecordCoreData.trackerDoneDate), startOfDay as NSDate, endOfDay as NSDate)
        
        if let result = try? context.fetch(request) {
            for object in result {
                context.delete(object)
            }
            do {
                try context.save()
            } catch {
                throw TrackerRecordStoreError.decodingErrorInvalidTrackerID
            }
        }
    }
    
    func isTrackerCompletedToday(_ id: UUID, _ date: Date) -> Bool {
        let completedTrackers = try? fetchTrackerRecord()
        return completedTrackers?.contains { trackerRecord in
            compareTrackerRecord(trackerRecord: trackerRecord, id: id, date: date)
        } ?? false
    }
    
    private func compareTrackerRecord(trackerRecord: TrackerRecord, id: UUID, date: Date) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.trackerDoneDate, inSameDayAs: date)
        return trackerRecord.trackerID == id && isSameDay
    }
    
    func getCompletedTrackers() -> Int {
        guard let completedTrackers = try? fetchTrackerRecord() else { return 0 }
        return completedTrackers.count
    }
    
    func delTrackerRecords(_ id: UUID) throws {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "(%K == %@)",
            #keyPath(TrackerRecordCoreData.trackerID), id as CVarArg)
        
        if let result = try? context.fetch(request) {
            for object in result {
                context.delete(object)
            }
            do {
                try context.save()
            } catch {
                throw TrackerRecordStoreError.decodingErrorInvalidTrackerID
            }
        }
    }
    
    func getAverage() -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.resultType = .dictionaryResultType
        request.returnsObjectsAsFaults = false
        request.propertiesToFetch = ["trackerDoneDate"]
        request.propertiesToGroupBy = ["trackerDoneDate", "trackerID"]
        let trackerDays = try! context.fetch(request)
        switch trackerDays.count == 0 {
        case true: return 0
        case false: return getCompletedTrackers() / trackerDays.count
        }
    }
    
    func getCompletedRecordsForTracker(_ id: UUID) -> Int {
        var answer = 0
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(
            format: "(%K == %@)",
            #keyPath(TrackerRecordCoreData.trackerID), id as CVarArg)
        
        if let result = try? context.fetch(request) {
            answer = result.count
        }
        return answer
    }
}
