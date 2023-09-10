//
//  ModuleItemListViewModel.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 05.09.2023.
//

import Foundation
import Dependencies
import CoreData
import Combine

final class ModuleItemListViewModel: ObservableObject {
    @Dependency(\.persistent) var store
    
    @Published var services = [Service]()
    @Published var features = [Feature]()
    @Published var models = [DataModel]()
    @Published var present: Present?
    
    let module: Module
    private var disposables = Set<AnyCancellable>()
    
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
    
    func deleteService(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let toDelete = services[index]
        toDelete.deletedAt = Date()
        store.save()
    }
    
    func deleteFeature(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let toDelete = features[index]
        toDelete.deletedAt = Date()
        store.save()
    }
    
    func deleteModel(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let toDelete = models[index]
        toDelete.deletedAt = Date()
        store.save()
    }
    
    func addService() {
        present = .addService
    }
    
    func addFeature() {
        present = .addFeature
    }
    
    func addDataModel() {
        present = .addModel
    }
    
    func present(_ item: Present) {
        self.present = item
    }
    
    func save() {
        store.save()
    }
    
    func makeFeatureModel() -> Feature {
        let feature = Feature(context: store.context)
        feature.createdAt = Date()
        feature.id = UUID()
        feature.parentId = module.id!
        feature.attributedText = .empty
        return feature
    }
    
    func makeServiceModel() -> Service {
        let feature = Service(context: store.context)
        feature.createdAt = Date()
        feature.id = UUID()
        feature.parentId = module.id!
        return feature
    }
    
    func makeDataModel() -> DataModel {
        let feature = DataModel(context: store.context)
        feature.createdAt = Date()
        feature.id = UUID()
        feature.parentId = module.id!
        return feature
    }
    
    private func bind() {
        NotificationCenter.default.publisher(for: NSManagedObjectContext.didSaveObjectsNotification)
            .sink { notification in
                self.load()
            }
            .store(in: &disposables)
    }
}

extension Module {
    static var preview: Module {
        @Dependency(\.persistent) var store
        let module = Module(context: store.context)
        module.title = "Тестовый Модуль"
        module.subtitle = "Lorem Ipsum - это текст-\"рыба\", часто используемый в печати и вэб-дизайне. Lorem Ipsum является стандартной \"рыбой\" для текстов на латинице с начала XVI века. В то время некий безымянный печатник создал большую коллекцию размеров и форм шрифтов, используя Lorem Ipsum для распечатки образцов. Lorem Ipsum не только успешно пережил без заметных изменений пять веков, но и перешагнул в электронный дизайн. Его популяризации в новое время послужили публикация листов Letraset с образцами Lorem Ipsum в 60-х годах и, в более недавнее время, программы электронной вёрстки типа Aldus PageMaker, в шаблонах которых используется Lorem Ipsum."
        module.id = UUID()
        module.createdAt = Date()
        return module
    }
}

extension ModuleItemListViewModel {
    enum Present: Identifiable, Hashable, CaseIterable {
        case addService
        case addFeature
        case addModel
        
        var id: Int {
            self.hashValue
        }
        
        var title: String {
            switch self {
            case .addService:
                return "Сервис"
            case .addModel:
                return "Модель"
            case .addFeature:
                return "Фичу"
            }
        }
        
        var iconName: String {
            switch self {
            case .addService:
                return "server.rack"
            case .addFeature:
                return "text.insert"
            case .addModel:
                return "tray.full"
            }
        }
    }
}
