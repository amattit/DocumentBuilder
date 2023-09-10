//
//  AddServiceViewModel.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 10.09.2023.
//

import Foundation
import Dependencies
import Combine
///  Относительный путь
///  Название сервиса общее
///  описание сервиса
///  квери переменные
///  боди
///  хэдеры
///  методы
///  описание
///  модель запроса
///  модель ответа
///  Модуль к которому относится
///  базовый путь модуля?

final class AddServiceViewModel: ObservableObject {
    @Dependency(\.persistent) var store
    /// Общее название сервиса
    @Published var title = ""
    
    /// Описание сервиса
    @Published var serviceDescription: NSAttributedString = .empty
    
    /// RelativePath
    @Published var relativePath = ""
    
    /// Headers
    @Published var headerViewModel = HeaderViewModel()
    
    /// Method
    @Published var method = Method.GET
    let methods = Method.allCases
    /// QueryItems
    @Published var queryViewModel: QueryParametersViewModel?
    
    /// RequestBody
    @Published var requestModel: DataModelViewModel?

    /// Response
    @Published var responseModel: DataModelViewModel?
    
    @Published var queryString = ""
    
    var disposables = Set<AnyCancellable>()
    
    let module: Module
    
    init(module: Module) {
        self.module = module
    }
    
    func createQueryViewModel() {
        queryViewModel = .init()
        if let queryViewModel {
            queryViewModel.$parameters.sink { attributes in
                let query = attributes
                    .filter { $0.isRequired == true }
                    .map {
                        "\($0.title)=\($0.type)"
                    }
                    .joined(separator: "&")
                
                self.queryString = query.isEmpty ? "" : "?\(query)"
            }
            .store(in: &disposables)
        }
    }
    
    func createRequestModel() {
        requestModel = DataModelViewModel(type: .network)
    }
    
    func createResponseModel() {
        responseModel = DataModelViewModel(type: .network)
    }
    
    func save() {
        let service = Service(context: store.context)
        service.id = UUID()
        service.parentId = module.id
        service.title = title
        service.path = relativePath
        service.method = method.rawValue
        service.createdAt = Date()
        
        headerViewModel.headers.forEach {
            let header = Header(context: store.context)
            header.id = $0.id
            header.parentId = service.id
            header.title = $0.title
            header.subtitle = $0.subtitle
            header.value = $0.value
        }
        
        if let queryViewModel {
            let _ = queryViewModel.parameters.map {
                let attribute = QueryAttributes(context: store.context)
                attribute.id = $0.id
                attribute.parentId = service.id
                attribute.title = $0.title
                attribute.createdAt = Date()
                attribute.comment = $0.comment
                attribute.isRequired = $0.isRequired
                attribute.objectType = $0.type
            }
        }
        
        if let requestModel {
            let dataModel = DataModel(context: store.context)
            dataModel.id = requestModel.model.id
            dataModel.title = requestModel.model.title
            dataModel.subtitle = requestModel.model.subtitle
            dataModel.createdAt = Date()
            dataModel.parentId = service.id
            dataModel.modelType = requestModel.modelType.rawValue
            dataModel.moduleId = module.id
            
            
            let _ = requestModel.attributes.map {
                let attribute = DataModelAttributes(context: store.context)
                attribute.id = $0.id
                attribute.parentId = dataModel.id
                attribute.title = $0.title
                attribute.createdAt = Date()
                attribute.comment = $0.comment
                attribute.isRequired = $0.isRequired
                attribute.objectType = $0.type
                return attribute
            }
        }
        
        if let responseModel {
            let dataResponseModel = DataModel(context: store.context)
            dataResponseModel.id = responseModel.model.id
            dataResponseModel.title = responseModel.model.title
            dataResponseModel.subtitle = responseModel.model.subtitle
            dataResponseModel.createdAt = Date()
            dataResponseModel.parentId = service.id
            dataResponseModel.modelType = responseModel.modelType.rawValue
            dataResponseModel.moduleId = module.id
            
            
            let _ = responseModel.attributes.map {
                let attribute = DataModelAttributes(context: store.context)
                attribute.id = $0.id
                attribute.parentId = dataResponseModel.id
                attribute.title = $0.title
                attribute.createdAt = Date()
                attribute.comment = $0.comment
                attribute.isRequired = $0.isRequired
                attribute.objectType = $0.type
                return attribute
            }
        }
        
        store.save()
    }
    
    func removeRequestModel() {
        requestModel = nil
    }
    
    func removeResponsemodel() {
        responseModel = nil
    }
    
    func removeQueryModel() {
        queryViewModel = nil
    }
}
