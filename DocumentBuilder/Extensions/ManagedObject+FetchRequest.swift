//
//  ManagedObject+FetchRequest.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 04.09.2023.
//

import CoreData

extension NSManagedObject {
    
    static func makeFetchRequest<T>(
        sortDescriptors: [NSSortDescriptor]? = nil,
        predicate: NSPredicate? = nil,
        limit: Int = 0
    ) -> NSFetchRequest<T> {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        if limit > 0 {
            fetchRequest.fetchLimit = limit
        }
        return fetchRequest
    }
    
}
