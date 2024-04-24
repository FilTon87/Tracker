//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Anton Filipchuk on 07.04.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    private let context: NSManagedObjectContext
    
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
    
}
