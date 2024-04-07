//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Anton Filipchuk on 07.04.2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}
