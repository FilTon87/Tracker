//
//  RecordDataProvider.swift
//  Tracker
//
//  Created by Anton Filipchuk on 27.04.2024.
//

import UIKit
import CoreData

struct RecordUpdate {
    let insertedIndexes: IndexSet
    let deleteIndexes: IndexSet
}

protocol RecordDataProviderDelegate: AnyObject {
    func update(_ update: RecordUpdate)
}

protocol RecordProtocol {
    func fetchTrackerRecord() throws -> [TrackerRecord]
    func addRecord(_ record: TrackerRecord) throws
    func delRecord(_ record: TrackerRecord)
    func delTrackerRecords(_ id:UUID)
    func isTrackerCompletedToday(_ id: UUID, _ date: Date) -> Bool
    func getCompletedRecordsForTracker(_ id: UUID) -> Int
}


final class RecordDataProvider: NSObject {
    
    weak var delegate: RecordDataProviderDelegate?
    private let context: NSManagedObjectContext
    private let dataStore: TrackerRecordStore
    private var insertedIndexes: IndexSet?
    private var deleteIndexes: IndexSet?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "trackerID", ascending: false)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    init(_ dataStore: TrackerRecordStore, delegate: RecordDataProviderDelegate) throws {
        self.delegate = delegate
        self.dataStore = dataStore
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}

extension RecordDataProvider: RecordProtocol {
    func addRecord(_ record: TrackerRecord) throws {
        try? dataStore.saveTrackerRecord(record)
    }
    
    func delRecord(_ record: TrackerRecord) {
        try? dataStore.delTrackerRecord(record)
    }
    
    func isTrackerCompletedToday(_ id: UUID, _ date: Date) -> Bool {
        dataStore.isTrackerCompletedToday(id, date)
    }
    
    func fetchTrackerRecord() throws -> [TrackerRecord] {
        try dataStore.fetchTrackerRecord()
    }
    
    func delTrackerRecords(_ id:UUID) {
        try? dataStore.delTrackerRecords(id)
    }
    
    func getCompletedRecordsForTracker(_ id: UUID) -> Int {
        dataStore.getCompletedRecordsForTracker(id)
    }
    
}


extension RecordDataProvider: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deleteIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.update(RecordUpdate(insertedIndexes: insertedIndexes!, deleteIndexes: deleteIndexes!))
        insertedIndexes = nil
        deleteIndexes = nil
    }
    
    func controller(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
            switch type {
            case .insert:
                if let indexPath = newIndexPath {
                    insertedIndexes?.insert(indexPath.item)
                }
            case .delete:
                if let indexPath = indexPath {
                    deleteIndexes?.insert(indexPath.item)
                }
            default: break
            }
        }
}

