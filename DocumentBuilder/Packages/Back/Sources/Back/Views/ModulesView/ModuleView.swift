//
//  File.swift
//  
//
//  Created by Михаил Серегин on 26.10.2023.
//

import SwiftUI
import Dependencies
import Core

struct ModuleView: View {
    @ObservedObject var viewModel: ModuleViewModel
    
    var body: some View {
        List {
            Text(viewModel.module.title ?? "N/A")
                .font(.largeTitle)
            Text("Сервисы")
                .font(.title2)
            ForEach(viewModel.services) { service in
                NavigationLink(value: service) {
                    ServiceRow(viewModel: service)
                }
                .swipeActions {
                    Button("Что то") {}
                }
            }
            Text("Транспортные модели")
                .font(.title2)
            
//            Text("Модели базы данных")
//                .font(.title2)
            // TODO: Добавить описание для баз данных
        }
        .sheet(item: $viewModel.present) { item in
            switch item {
            case .addService:
                AddServiceView(viewModel: .init(module: viewModel.module))
            }
        }
        .toolbar(content: {
            ToolbarItem {
                Button("+ сервис") {
                    viewModel.addService()
                }
            }
        })
    }
}

@MainActor
final class ModuleViewModel: ObservableObject {
    @Published var module: Module
    @Published var present: Present?
    
    var services: [Service] {
        Array((module.services as? Set<Service>) ?? [])
    }
    
    var models: [DataModel] {
        Array((module.dataModels as? Set<DataModel>) ?? [])
    }
    
    init(module: Module) {
        self.module = module
    }
    
    func addService() {
        present = .addService
    }
}

extension ModuleViewModel {
    enum Present: Identifiable, Hashable {
        case addService
        
        var id: Int { hashValue }
    }
}

struct ServiceRow: View {
    @ObservedObject var viewModel: Service
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.title ?? "N/A")
            Text(viewModel.path ?? "N/A")
                .font(.footnote)
                .foregroundStyle(.secondary)
            
        }
    }
}
