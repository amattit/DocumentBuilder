//
//  File.swift
//  
//
//  Created by Михаил Серегин on 27.10.2023.
//

import Foundation
import Dependencies
import CoreData

public actor ServiceRepository {
    @Dependency(\.persistent) var store
    
    private let module: Module
    private var sortDescriptors: [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \Service.createdAt, ascending: true)
        ]
    }
    
    public init(module: Module) {
        self.module = module
    }
    
    public func get() -> [Service] {
        module.wrappedServices
    }
    
    public func fastCreate(with title: String, path: String, method: String) throws {
        let service = makeService(with: title, path: path, method: method)
        module.addToServices(service)
        try store.context.save()
    }
    
    private func makeService(with title: String, path: String, method: String) -> Service {
        let service = Service(context: store.context)
        service.id = .init()
        service.title = title
        service.path = path
        service.method = method
        service.createdAt = Date()
        
        return service
    }
}
