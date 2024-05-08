//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Anton Filipchuk on 08.05.2024.
//

import Foundation

final class CategoryViewModel {

    var isData: Observable<Bool> = Observable(false)
    
    var categories: [TrackerCategory]?
    
    private let dataStore = TrackerCategoryStore.shared
    
    func getCategories() {
        do {
            categories = try dataStore.fetchCategory()
        } catch {
            assertionFailure("Faild do recive Categories")
        }
        checkData()
    }
    
    func checkData() {
        if categories?.count ?? 0 > 0 {
            isData.value = true
        }
    }

    func numbersOfRowsInSection(_ section: Int) -> Int {
        categories?.count ?? 0
    }
    
    func object(at indexPath: IndexPath) -> TrackerCategory? {
        let object = categories?[indexPath.row]
        return object
    }
    
    func addCategory(_ category: TrackerCategory) throws {
        try? dataStore.addCategory(category)
        getCategories()
    }
}
