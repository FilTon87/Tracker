//
//  TrackerDataProvider.swift
//  Tracker
//
//  Created by Anton Filipchuk on 26.04.2024.
//

import UIKit
import CoreData

protocol TrackerDataProviderDelegate: AnyObject { }

protocol TrackerProtocol {
    func addTracker(_ tracker: Tracker, _ category: String) throws
}

final class TrackerDataProvider: NSObject {
    
    weak var delegate: TrackerDataProviderDelegate?
    private let context: NSManagedObjectContext
    private let dataStore: TrackerStore
    private var insertedIndexes: IndexSet?
    private var deleteIndexes: IndexSet?
    
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
        
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    init(_ dataStore: TrackerStore, delegate: TrackerDataProviderDelegate) throws {
        self.delegate = delegate
        self.dataStore = dataStore
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}

extension TrackerDataProvider: TrackerProtocol {
    func addTracker(_ tracker: Tracker, _ category: String) throws {
        try? dataStore.addNewTracker(tracker, category)
    }
}


extension TrackerDataProvider: NSFetchedResultsControllerDelegate { }
