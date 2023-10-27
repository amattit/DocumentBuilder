//
//  File.swift
//  
//
//  Created by Михаил Серегин on 27.10.2023.
//

import CoreData

extension NSSet {
    func toArray<T>() -> [T] {
        self.compactMap { $0 as? T }
    }
}
