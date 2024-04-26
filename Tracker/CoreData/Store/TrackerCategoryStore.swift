//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Anton Filipchuk on 07.04.2024.
//

import UIKit
import CoreData

private enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidCategoryTitle
    case decodingErrorInvalidCategoryTrackers
}

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    static let shared = TrackerCategoryStore()
    
    private lazy var trackerStore: TrackerStore = {
        TrackerStore(context: context)
    }()
    
    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

extension TrackerCategoryStore {
    func addCategory(_ category: TrackerCategory) throws {
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.categoryTitle = category.categoryTitle
        try context.save()
    }
    
    func delCategory(_ category: NSManagedObject) throws {
        
    }
    
    func fetchCategory() throws -> [TrackerCategory] {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        let categoryFromCoreData = try context.fetch(fetchRequest)
        return try categoryFromCoreData.map { try self.convertToTrackerCategory(from: $0) }
    }
    
    func convertToTrackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let categoryTitle = trackerCategoryCoreData.categoryTitle else {
            throw TrackerCategoryStoreError.decodingErrorInvalidCategoryTitle
        }
        
        guard let trackersList = trackerCategoryCoreData.trackers?.allObjects as? [TrackerCoreData] else {
            throw TrackerCategoryStoreError.decodingErrorInvalidCategoryTrackers
        }
        
        let categoryTrackers = try trackersList.compactMap { trackerCoreDate in
            guard let tracker = try? trackerStore.convertToTracker(trackerCoreDate) else {
                throw TrackerCategoryStoreError.decodingErrorInvalidCategoryTrackers
            }
            return tracker
        }
        
        return TrackerCategory(
            categoryTitle: categoryTitle,
            trackers: categoryTrackers)
    }
    
    func fetchCategoryName(_ name: String) -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.categoryTitle), name)
        
        let category = try! context.fetch(request)
        
        if category.count > 0 { return category[0] } else { return nil }
    }
}
