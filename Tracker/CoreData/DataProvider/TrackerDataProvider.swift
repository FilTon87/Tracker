//
//  TrackerDataProvider.swift
//  Tracker
//
//  Created by Anton Filipchuk on 26.04.2024.
//

import UIKit
import CoreData

protocol TrackerProtocol {
    func addTracker(_ tracker: Tracker, _ category: String) throws
    func delTracker(_ id: UUID)
    func pinTracker(_ id: UUID)
    func getTracker(_ id: UUID) -> Tracker?
}

final class TrackerDataProvider: NSObject {
    
    private let context: NSManagedObjectContext
    private let dataStore: TrackerStore
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "trackerName", ascending: false)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    init(_ dataStore: TrackerStore) throws {
        self.dataStore = dataStore
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}

extension TrackerDataProvider: TrackerProtocol {
    func addTracker(_ tracker: Tracker, _ category: String) throws {
        try? dataStore.addNewTracker(tracker, category)
    }
    
    func delTracker(_ id: UUID) {
        try? dataStore.delTracker(id)
    }
    
    func pinTracker(_ id: UUID) {
        try? dataStore.pinTracker(id)
    }
    
    func getTracker(_ id: UUID) -> Tracker? {
        dataStore.getTracker(id)
    }
}
