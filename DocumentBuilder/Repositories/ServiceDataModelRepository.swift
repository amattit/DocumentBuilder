//
//  ServiceDataModelRepository.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 11.09.2023.
//

import Foundation
import Dependencies

protocol ServiceDataModelRepositoryProtocol {
    func add(_ dataModel: DataModel, to service: Service, type: ServiceDataModelRepository.RelationType)
    func remove(_ dataModel: DataModel, ftom service: Service) throws
    func getRelations(for service: Service) throws -> [ServiceDataModel]
}

class ServiceDataModelRepository: ServiceDataModelRepositoryProtocol {
    @Dependency(\.persistent) var store
    
    func add(_ dataModel: DataModel, to service: Service, type: RelationType) {
        let relation = ServiceDataModel(context: store.context)
        relation.id = UUID()
        relation.serviceId = service.id
        relation.dataModelId = dataModel.id
        relation.type = type.rawValue

        store.save()
    }
    
    func remove(_ dataModel: DataModel, ftom service: Service) throws {
        let relation = try getRelation(for: service, and: dataModel)
        store.context.delete(relation)
        store.save()
    }
    
    func getRelations(for service: Service) throws -> [ServiceDataModel] {
        guard let serviceId = service.id?.uuidString else { throw Error.noId }
        let request = ServiceDataModel.fetchRequest()
        request.predicate = NSPredicate(format: "serviceId = %@", serviceId)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ServiceDataModel.type, ascending: true)]
        return try store.context.fetch(request)
    }
    
    private func getRelation(for service: Service, and dataModel: DataModel) throws -> ServiceDataModel {
        guard let serviceId = service.id, let dataModelId = dataModel.id else {
            throw Error.noId
        }
        let request = ServiceDataModel.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ServiceDataModel.id, ascending: true)]
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "serviceId = %@", serviceId.uuidString),
            NSPredicate(format: "dataModelId = %@", dataModelId.uuidString)
        ])
        
        request.predicate = predicate
        
        guard let model = try store.context.fetch(request).first
        else { throw Error.noRelation }
        return model
    }
    
    enum RelationType: String {
        case request, response
    }
}

enum ServiceDataModelRepositoryKey: DependencyKey {
    static var liveValue: ServiceDataModelRepositoryProtocol = ServiceDataModelRepository()
}

extension DependencyValues {
    var serviceDataModelRepository: ServiceDataModelRepositoryProtocol {
        get { self[ServiceDataModelRepositoryKey.self] }
        set { self[ServiceDataModelRepositoryKey.self] = newValue }
    }
}


