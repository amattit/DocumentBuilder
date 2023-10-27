////
////  ServiceView.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 12.09.2023.
////
//
//import SwiftUI
//
//struct ServiceView: View {
//    @ObservedObject var viewModel: ServiceViewModel
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                ServiceName
//                
//                RelativePath
//                
//                HTTPMethod
//                
//                if let viewModel = viewModel.queryViewModel {
//                    QueryParametersView(viewModel: viewModel)
//                }
//                
//                if let viewModel = viewModel.headerViewModel {
//                    HeaderView(viewModel: viewModel)
//                }
//                
//                if let viewModel = viewModel.requestModel {
//                    DataModelView(viewModel: viewModel)
//                }
//                
//                if let viewModel = viewModel.responseModel {
//                    DataModelView(viewModel: viewModel)
//                }
//            }
//            .padding(16)
//        }
//        .onDisappear {
//            viewModel.save()
//        }
//        .navigationTitle(Text("Сервис: \(viewModel.service.title ?? "")"))
//    }
//    
//    var ServiceName: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            TextField("Введите имя сервиса, например, \"Запрос на создание задачи\"", text: $viewModel.title)
//                .font(.largeTitle)
//                .textFieldStyle(.plain)
//        }
//    }
//    
//    var RelativePath: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            HStack {
//                Text("Относительный путь")
//                Text(viewModel.relativePath + viewModel.queryString)
//            }
//            TextField("/some/path"+viewModel.queryString, text: $viewModel.relativePath)
//        }
//    }
//    var HTTPMethod: some View {
//        HTTPMethodView(items: Method.allCases, selected: $viewModel.method)
//    }
//}
//
//
//import Dependencies
//import Combine
//
//final class ServiceViewModel: ObservableObject {
//    @Dependency(\.dataModelRepository) var modelRepository
//    @Dependency(\.serviceDataModelRepository) var relationRepository
//    @Dependency(\.serviceRepository) var serviceRepository
//    
//    @Published var title: String
//    @Published var relativePath: String
//    @Published var queryString = ""
//    @Published var method: Method
//    
//    @Published var headerViewModel: EditHeaderViewModel?
//    @Published var queryViewModel: EditQueryParametersViewModel?
//    @Published var requestModel: EditDataModelViewModel?
//    @Published var responseModel: EditDataModelViewModel?
//    
//    let service: Service
//    let module: Module
//    
//    var relations: [ServiceDataModel] = []
//    var disposables = Set<AnyCancellable>()
//    
//    init(service: Service, module: Module) {
//        self.service = service
//        self.module = module
//        self.title = service.title ?? ""
//        self.relativePath = service.path ?? ""
//        
//        if let httpMethod = service.method, let method = Method(rawValue: httpMethod) {
//            self.method = method
//        } else {
//            self.method = .GET
//        }
//        
//        getRelations()
//        getHeaders()
//        getQuery()
//        getRequestModel()
//        getResponseModel()
//    }
//    
//    func getHeaders() {
//        tryAction {
//            let items = try serviceRepository.getHeaders(for: service)
//            self.headerViewModel = try .init(headers: items, service: service)
//        }
//    }
//    
//    func getQuery() {
//        tryAction {
//            let items = try serviceRepository.getQuery(for: service)
//            self.queryViewModel = try .init(query: items)
//            createQueryParametersBind()
//        }
//    }
//    
//    func getRequestModel() {
//        tryAction {
//            if let id = relations.first(where: { $0.type == ServiceDataModelRepository.RelationType.request.rawValue })?.dataModelId {
//                let model = try modelRepository.getModel(by: id.uuidString)
//                let attributes = try modelRepository.getAtributes(for: model)
//                requestModel = try .init(dataMode: model, attributes: attributes)
//            }
//        }
//    }
//    
//    func getResponseModel() {
//        tryAction {
//            if let id = relations.first(where: { $0.type == ServiceDataModelRepository.RelationType.response.rawValue })?.dataModelId {
//                let model = try modelRepository.getModel(by: id.uuidString)
//                let attributes = try modelRepository.getAtributes(for: model)
//                responseModel = try .init(dataMode: model, attributes: attributes)
//            }
//        }
//    }
//    
//    func getRelations() {
//        tryAction {
//            self.relations = try relationRepository.getRelations(for: service)
//        }
//    }
//    
//    func save() {
//        if let requestModel {
//            requestModel.update()
//        }
//        
//        if let responseModel {
//            responseModel.update()
//        }
//        
//        if let headerViewModel {
//            headerViewModel.update()
//        }
//        
//        if let queryViewModel {
//            queryViewModel.update()
//        }
//    }
//    
//    private func createQueryParametersBind() {
//        if let queryViewModel {
//            queryViewModel.$parameters.sink { attributes in
//                let query = attributes
//                    .filter { $0.isRequired == true }
//                    .map {
//                        "\($0.title)=\($0.type)"
//                    }
//                    .joined(separator: "&")
//                
//                self.queryString = query.isEmpty ? "" : "?\(query)"
//            }
//            .store(in: &disposables)
//        }
//    }
//}
