//
//  File.swift
//  
//
//  Created by Михаил Серегин on 25.10.2023.
//

import Foundation
import CoreData
import Dependencies

public actor ModuleRepository {
    @Dependency(\.persistent) private var store
    
    private var sortDescriptors: [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \Module.createdAt, ascending: true)
        ]
    }
    
    public func getModules() throws -> [Module] {
        let requeest = Module.fetchRequest()
        requeest.sortDescriptors = self.sortDescriptors
        
        return try store.context.fetch(requeest)
    }
    
    public func create(_ title: String, subtitle: String) throws {
        let module = Module(context: store.context)
        module.id = UUID()
        module.title = title
        module.subtitle = subtitle
        module.createdAt = Date()
        
        try store.context.save()
    }
    
    public func update(title: String?, subtitle: String?, moduleId: UUID) throws {
        let request = Module.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", moduleId.uuidString)
        request.sortDescriptors = self.sortDescriptors
        let items = try store.context.fetch(request)
        if let item = items.first(where: {
            $0.id == moduleId
        }) {
            if let title {
                item.title = title
            }
            
            if let subtitle {
                item.subtitle = subtitle
            }
            
            item.updatedAt = Date()
            
        }
        
        try store.context.save()
    }
    
    public func delete(module id: UUID) throws {
        let request = Module.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        request.sortDescriptors = self.sortDescriptors
        let items = try store.context.fetch(request)
        if let first = items.first(where: {
            $0.id == id
        }) {
            store.context.delete(first)
        }
        
        try store.context.save()
    }
}

enum Error: Swift.Error {
    
}

extension ModuleRepository: DependencyKey {
    public static var liveValue: ModuleRepository = ModuleRepository()
    public static var testValue: ModuleRepository = .liveValue
    public static var previewValue: ModuleRepository = .liveValue
}

public extension DependencyValues {
    var modulesRepository: ModuleRepository {
        get { self[ModuleRepository.self] }
        set { self[ModuleRepository.self] = newValue }
    }
}
