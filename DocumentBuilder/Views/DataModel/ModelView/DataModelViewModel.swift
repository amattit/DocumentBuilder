//
//  DataModelViewModel.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 16.09.2023.
//

import Foundation
import Dependencies

/// Абстрактный класс для DataModelView?
class DataModelViewModel: ObservableObject {
    @Dependency(\.persistent) var store
    
    @Published var model: Model = .init(id: UUID(), title: "", subtitle: "")
    @Published var attributes: [ModelAttribute] = []
    @Published var selectedAttributes = Set<ModelAttribute.ID>()
    
    var modelType: ModelType
    
    /// init для создания
    init(type: ModelType) {
        self.modelType = type
    }
    
    init(dataMode: DataModel, attributes: [DataModelAttributes]) throws {
        self.model = try .init(with: dataMode)
        self.attributes = try attributes.compactMap(ModelAttribute.init)
        
        if let modelType = dataMode.modelType, let type = ModelType(rawValue: modelType) {
            self.modelType = type
        } else {
            modelType = .plain
        }
    }
    
    func addAttribute() {
        attributes.append(.init(id: .init(), title: "", type: "", isRequired: false, comment: "", parentId: model.id))
    }
    
    func removeAttributes() {
        selectedAttributes.forEach { id in attributes.removeAll { $0.id == id } }
    }
}

import Combine

class EditDataModelViewModel: DataModelViewModel {
    private let hostModel: Model
    private let hostAttributes: [ModelAttribute]
    
    private let hostModelEntity: DataModel
    private let hostAttributesEntity: [DataModelAttributes]
    
    private var deletedAttributes: [UUID] = []
    private var insertedAttributes: [UUID] = []
    
    override init(dataMode: DataModel, attributes: [DataModelAttributes]) throws {
        self.hostModel = try .init(with: dataMode)
        self.hostAttributes = try attributes.compactMap(ModelAttribute.init)
        self.hostModelEntity = dataMode
        self.hostAttributesEntity = attributes
        
        try super.init(dataMode: dataMode, attributes: attributes)
    }
    
    override func addAttribute() {
        let attribute = ModelAttribute(id: .init(), title: .init(), type: .init(), isRequired: false, comment: .init(), parentId: model.id)
        self.attributes.append(attribute)
        self.insertedAttributes.append(attribute.id)
    }
    
    override func removeAttributes() {
        let removed = attributes.filter { selectedAttributes.contains($0.id) }.map(\.id)
        deletedAttributes += removed
        super.removeAttributes()
    }
    
    func update() {
        // Обновление модели
        if hostModel != model {
            hostModelEntity.title = model.title
            hostModelEntity.subtitle = model.subtitle
            hostModelEntity.updatedAt = Date()
        }
        
        // Удаление Атрибутов
        deletedAttributes.forEach { deletedId in
            if let hostAttribute = hostAttributesEntity.first(where: { $0.id == deletedId }) {
                hostAttribute.deletedAt = Date()
            }
        }
        
        // Изменение существующих
        attributes.forEach { attribute in
            if let hostAttribute = hostAttributes.first(where: { host in
                host.id == attribute.id
            }) {
                if hostAttribute != attribute {
                    let entity = getAttributeEntity(for: attribute)
                    entity?.title = attribute.title
                    entity?.objectType = attribute.type
                    entity?.isRequired = attribute.isRequired
                    entity?.comment = attribute.comment
                }
            }
        }
        
        // Добавление атрибутов
        insertedAttributes.forEach { insertedId in
            if let insertedAttribute = attributes.first (where: { $0.id == insertedId}) {
                let entity = DataModelAttributes(context: store.context)
                entity.id = insertedAttribute.id
                entity.title = insertedAttribute.title
                entity.objectType = insertedAttribute.type
                entity.isRequired = insertedAttribute.isRequired
                entity.comment = insertedAttribute.comment
                entity.parentId = insertedAttribute.parentId
                entity.createdAt = Date()
            }
        }
        
        store.save()
    }
    
    func getAttributeEntity(for attribute: ModelAttribute) -> DataModelAttributes? {
        hostAttributesEntity.first { entity in
            entity.id == attribute.id
        }
    }
}
