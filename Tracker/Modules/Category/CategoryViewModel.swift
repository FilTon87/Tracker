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
        updateCategories()
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
        updateCategories()
        checkData()
    }
    
    func getIndexPath(_ selectedCategory: String) -> Int {
        updateCategories()
        checkData()
        let searchingCategory = TrackerCategory(categoryTitle: selectedCategory, trackers: [])
        guard let index = categories.firstIndex(of: searchingCategory) else { return 0 }
        return index
    }
    
    func updateCategories() {
        do {
            categories = try dataStore.fetchCategory()
        } catch {
            assertionFailure("Faild do recive Categories")
        }
    }
    
}
