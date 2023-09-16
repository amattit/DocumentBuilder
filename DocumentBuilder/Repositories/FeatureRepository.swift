//
//  FeatureRepository.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 10.09.2023.
//

import Foundation
import Dependencies

protocol FeatureRepositoryProtocol {
    func getFeatures(for module: Module) throws -> [Feature]
    func delete(_ feature: Feature)
}

class FeatureRepository: FeatureRepositoryProtocol {
    @Dependency(\.persistent) var store
    
    func getFeatures(for module: Module) throws -> [Feature] {
        let request = Feature.fetchRequest()
        request.predicate = try getPredicate(for: module)
        request.sortDescriptors = getSortDescriptor()
        return try store.context.performAndWait({
            try store.context.fetch(request)
        })
    }
    
    func delete(_ feature: Feature) {
        feature.deletedAt = Date()
        store.save()
    }
    
    func getPredicate(for module: Module) throws -> NSPredicate {
        guard let moduleId = module.id else { throw Error.noModuleId }
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "parentId == %@", moduleId.uuidString),
            NSPredicate(format: "deletedAt == nil"),
        ])
        
        return predicate
    }
    
    func getSortDescriptor() -> [NSSortDescriptor] {
        [NSSortDescriptor(keyPath: \Feature.title, ascending: true)]
    }
}

enum FeatureRepositoryKey: DependencyKey {
    static var liveValue: FeatureRepositoryProtocol = FeatureRepository()
}

extension DependencyValues {
    var featureRepository: FeatureRepositoryProtocol {
        get { self[FeatureRepositoryKey.self] }
        set { self[FeatureRepositoryKey.self] = newValue }
    }
}
