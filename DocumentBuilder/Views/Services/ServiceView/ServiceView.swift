//
//  ServiceView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 12.09.2023.
//

import SwiftUI

struct ServiceView: View {
    @ObservedObject var viewModel: ServiceViewModel
    
    var body: some View {
        ScrollView {
            
            if let viewModel = viewModel.queryViewModel {
                QueryParametersView(viewModel: viewModel)
            }
            
            if let viewModel = viewModel.headerViewModel {
                HeaderView(viewModel: viewModel)
            }
            
            if let viewModel = viewModel.requestModel {
                DataModelView(viewModel: viewModel)
            }
            
            if let viewModel = viewModel.responseModel {
                DataModelView(viewModel: viewModel)
            }
        }
    }
}


import Dependencies

final class ServiceViewModel: ObservableObject {
    @Dependency(\.dataModelRepository) var modelRepository
    @Dependency(\.serviceDataModelRepository) var relationRepository
    @Dependency(\.serviceRepository) var serviceRepository
    
    @Published var headerViewModel: HeaderViewModel?
    @Published var queryViewModel: QueryParametersViewModel?
    @Published var requestModel: DataModelViewModel?
    @Published var responseModel: DataModelViewModel?
    
    let service: Service
    let module: Module
    
    var relations: [ServiceDataModel] = []
    
    init(service: Service, module: Module) {
        self.service = service
        self.module = module
        getRelations()
        getHeaders()
        getQuery()
        getRequestModel()
        getResponseModel()
    }
    
    func getHeaders() {
        do {
            let items = try serviceRepository.getHeaders(for: service)
            self.headerViewModel = .init(headers: items)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getQuery() {
        do {
            let items = try serviceRepository.getQuery(for: service)
            self.queryViewModel = .init(query: items)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getRequestModel() {
        do {
            if let id = relations.first(where: { $0.type == ServiceDataModelRepository.RelationType.request.rawValue })?.dataModelId {
                let model = try modelRepository.getModel(by: id.uuidString)
                let attributes = try modelRepository.getAtributes(for: model)
                requestModel = .init(dataMode: model, attributes: attributes)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getResponseModel() {
        do {
            if let id = relations.first(where: { $0.type == ServiceDataModelRepository.RelationType.response.rawValue })?.dataModelId {
                let model = try modelRepository.getModel(by: id.uuidString)
                let attributes = try modelRepository.getAtributes(for: model)
                responseModel = .init(dataMode: model, attributes: attributes)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getRelations() {
        do {
            self.relations = try relationRepository.getRelations(for: service)
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
