//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Anton Filipchuk on 08.05.2024.
//

import Foundation

final class CategoryViewModel {

    var isData: Observable<Bool> = Observable(false)
    var numbersOfRows: Int = 0
    
    private var categories: [TrackerCategory] = []
    private var loadedCategories: [TrackerCategory] = []
    
    private let dataStore = TrackerCategoryStore.shared
    
    func getCategories() -> [TrackerCategory] {
        do {
            categories = try dataStore.fetchCategory()
        } catch {
            assertionFailure("Faild do recive Categories")
        }
        checkData()
        return categories
    }
    
    func checkData() {
        if categories.count > 0 {
            isData.value = true
            numbersOfRows = categories.count
        }
    }
    
    func object(at indexPath: IndexPath) -> TrackerCategory? {
        let object = categories[indexPath.row]
        return object
    }
    
    func addCategory(_ category: TrackerCategory) throws {
        try? dataStore.addCategory(category)
        getCategories()
    }
}
