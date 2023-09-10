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
    @Dependency(\.serviceRepository) var serviceRepository
    @Dependency(\.dataModelRepository) var dataModelRepository
    @Dependency(\.featureRepository) var featureRepository
    
    @Published var services = [Service]()
    @Published var features = [Feature]()
    @Published var models = [DataModel]()
    @Published var present: Present?
    
    @Published var modelSections: [ModelType] = []
    
    let module: Module
    private var disposables = Set<AnyCancellable>()
    
    init(module: Module) {
        self.module = module
        load()
    }
    
    func load() {
        do {
            self.services = try serviceRepository.getServices(for: module)
            self.features = try featureRepository.getFeatures(for: module)
            self.models = try dataModelRepository.getDataModels(for: module)
            
            self.modelSections = Array(
                Set(self.models.map { .init(rawValue: $0.modelType ?? "") ?? .plain })
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getModels(for type: ModelType) -> [DataModel] {
        models.filter {
            $0.modelType == type.rawValue
        }
    }
    
    func deleteService(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let toDelete = services[index]
        serviceRepository.delete(toDelete)
    }
    
    func deleteFeature(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let toDelete = features[index]
        featureRepository.delete(toDelete)
    }
    
    func deleteModel(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let toDelete = models[index]
        dataModelRepository.delete(toDelete)
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
