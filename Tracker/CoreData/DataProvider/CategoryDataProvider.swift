//
//  CategoryDataProvider.swift
//  Tracker
//
//  Created by Anton Filipchuk on 24.04.2024.
//

import UIKit
import CoreData

struct CategoryUpdate {
    let insertedIndexes: IndexSet
    let deleteIndexes: IndexSet
}

protocol DataProviderDelegate: AnyObject {
    func update(_ update: CategoryUpdate)
}

protocol TrackerCategoryProtocol {
    var numbersOfSection: Int { get }
    func numbersOfRowsInSection(_ section: Int) -> Int
    func object(at indexPath: IndexPath) -> TrackerCategory?
    func addCategory(_ category: TrackerCategory) throws
    func delCategory(at indexPath: IndexPath) throws
    func fetchCategory() -> [TrackerCategory]
}

final class CategoryDataProvider: NSObject {
    
    weak var delegate: DataProviderDelegate?
    
    private let context: NSManagedObjectContext
    private let dataStore: TrackerCategoryStore
    private var insertedIndexes: IndexSet?
    private var deleteIndexes: IndexSet?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "categoryTitle", ascending: false)
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
    
    
    init(_ dataStore: TrackerCategoryStore, delegate: DataProviderDelegate) throws {
        self.delegate = delegate
        self.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.dataStore = dataStore
    }
}

extension CategoryDataProvider: TrackerCategoryProtocol {
    var numbersOfSection: Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numbersOfRowsInSection(_ section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func object(at indexPath: IndexPath) -> TrackerCategory? {
        let object = fetchedResultsController.object(at: indexPath)
        return try? TrackerCategoryStore.shared.convertToTrackerCategory(from: object)
    }
    
    func addCategory(_ category: TrackerCategory) throws {
        try? dataStore.addCategory(category)
    }
    
    func delCategory(at indexPath: IndexPath) throws {
        let category = fetchedResultsController.object(at: indexPath)
        try? dataStore.delCategory(category)
    }
    
    func fetchCategory() -> [TrackerCategory] {
        do {
            let categories = try dataStore.fetchCategory()
            return categories
        } catch {
            assertionFailure("No tracker categories")
            return []
        }
    }
}

extension CategoryDataProvider: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deleteIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        delegate?.update(CategoryUpdate(insertedIndexes: insertedIndexes!, deleteIndexes: deleteIndexes!))
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
