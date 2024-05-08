//
//  Observable.swift
//  Tracker
//
//  Created by Anton Filipchuk on 08.05.2024.
//

import Foundation

final class Observable<T> {
    var value: T? {
        didSet {
            self.listener?(self.value)
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    private var listener: ((T?) -> Void)?
    
    func bind(_ listener: @escaping((T?) -> Void)) {
        listener(value)
        self.listener = listener
    }
}
