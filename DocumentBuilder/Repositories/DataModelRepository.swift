//
//  DataModelRepository.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 10.09.2023.
//

import Foundation
import Dependencies

protocol DataModelRepositoryProtocol {
    func getDataModels(for module: Module) throws -> [DataModel]
    func delete(_ model: DataModel)
}

class DataModelRepository: DataModelRepositoryProtocol {
    @Dependency(\.persistent) var store
    
    func getDataModels(for module: Module) throws -> [DataModel] {
        let request = DataModel.fetchRequest()
        request.predicate = try getPredicate(for: module)
        request.sortDescriptors = getSortDescriptor()
        return try store.context.performAndWait({
            try store.context.fetch(request)
        })
    }
    
    func delete(_ model: DataModel) {
        model.deletedAt = Date()
        store.save()
    }
    
    func getPredicate(for module: Module) throws -> NSPredicate {
        guard let moduleId = module.id else { throw ServiceRepositoryError.noModuleId }
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "moduleId == %@", moduleId.uuidString),
            NSPredicate(format: "deletedAt == nil"),
        ])
        
        return predicate
    }
    
    func getSortDescriptor() -> [NSSortDescriptor] {
        [NSSortDescriptor(keyPath: \DataModel.title, ascending: true)]
    }
}

enum DataModelRepositoryKey: DependencyKey {
    static var liveValue: DataModelRepositoryProtocol = DataModelRepository()
}

extension DependencyValues {
    var dataModelRepository: DataModelRepositoryProtocol {
        get { self[DataModelRepositoryKey.self] }
        set { self[DataModelRepositoryKey.self] = newValue }
    }
}
