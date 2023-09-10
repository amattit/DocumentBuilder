//
//  ModuleViewModel.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 05.09.2023.
//

import Foundation
import Dependencies

final class ModuleViewModel: ObservableObject {
    @Dependency(\.persistent)  var store
    @Published var features = [Feature]()
    @Published var services = [Service]()
    @Published var models = [DataModel]()
    
    let module: Module
    
    init(module: Module) {
        self.module = module
        load()
    }
    
    func load() {
        guard let id = module.id?.uuidString else { return }
        // TODO: Добавить фильтр deletedAt != nil
        let parentIdPredicate = NSPredicate(format: "parentId == %@", id)
        let dateNotNilPredicate = NSPredicate(format: "deletedAt == nil")
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [parentIdPredicate, dateNotNilPredicate])
        
        let servicesRequest = Service.fetchRequest()
        servicesRequest.predicate = predicate
        servicesRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Service.title, ascending: true)]
        
        let featuresRequest = Feature.fetchRequest()
        featuresRequest.predicate = predicate
        featuresRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Feature.title, ascending: true)]
        
        let dataModelRequest = DataModel.fetchRequest()
        dataModelRequest.predicate = predicate
        dataModelRequest.sortDescriptors = [NSSortDescriptor(keyPath: \DataModel.title, ascending: true)]
        
        do {
            try store.context.performAndWait {
                self.services = try store.context.fetch(servicesRequest)
                self.features = try store.context.fetch(featuresRequest)
                self.models = try store.context.fetch(dataModelRequest)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func save() {
        store.save()
    }
}
