//
//  ServiceRepository.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 10.09.2023.
//

import Foundation
import Dependencies

protocol ServiceRepositoryProtocol {
    func getServices(for module: Module) throws -> [Service]
    func delete(_ service: Service)
}

class ServiceRepository: ServiceRepositoryProtocol {
    @Dependency(\.persistent) var store
    
    func getServices(for module: Module) throws -> [Service] {
        let request = Service.fetchRequest()
        request.predicate = try getPredicate(for: module)
        request.sortDescriptors = getSortDescriptor()
        return try store.context.performAndWait({
            try store.context.fetch(request)
        })
    }
    
    func delete(_ service: Service) {
        service.deletedAt = Date()
        store.save()
    }
    
    func getPredicate(for module: Module) throws -> NSPredicate {
        guard let moduleId = module.id else { throw ServiceRepositoryError.noModuleId }
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "parentId == %@", moduleId.uuidString),
            NSPredicate(format: "deletedAt == nil"),
        ])
        
        return predicate
    }
    
    func getSortDescriptor() -> [NSSortDescriptor] {
        [NSSortDescriptor(keyPath: \Service.title, ascending: true)]
    }
}

enum ServiceRepositoryError: Error {
    case noModuleId
    case cantCreatePredicate
}

enum ServiceRepositoryKey: DependencyKey {
    static var liveValue: ServiceRepositoryProtocol = ServiceRepository()
}

extension DependencyValues {
    var serviceRepository: ServiceRepositoryProtocol {
        get { self[ServiceRepositoryKey.self] }
        set { self[ServiceRepositoryKey.self] = newValue }
    }
}
