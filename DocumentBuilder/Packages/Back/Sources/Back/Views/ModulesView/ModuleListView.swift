//
//  SwiftUIView.swift
//  
//
//  Created by Михаил Серегин on 26.10.2023.
//

import SwiftUI
import Dependencies
import Core

struct ModuleListView: View {
    @ObservedObject var viewModel: ModuleListViewModel
    var body: some View {
        List {
            ForEach(viewModel.items) { module in
                NavigationLink(value: module) {
                    ModuleRow(viewModel: module)
                        .contextMenu(ContextMenu(menuItems: {
                            Button(action: {
                                Task {
                                    await viewModel.delete(module)
                                }
                            }) {
                                Label("Удалить", systemImage: "trash")
                            }
                        }))
                }
            }
        }
        .task {
            await viewModel.load()
        }
        .sheet(item: $viewModel.present) {
            Task {
                await viewModel.load()
            }
        } content: { item in
            switch item {
            case .add:
                AddModuleView(viewModel: .init())
            }
        }
        .toolbar(content: {
            ToolbarItem {
                
                Button(action: {
                    viewModel.showAddModule()
                }) {
                    Image(systemName: "plus")
                }
            }
        })

    }
}

#Preview {
    ContentView()
}

@MainActor
final class ModuleListViewModel: ObservableObject {
    @Dependency(\.modulesRepository) var repository
    @Published var items: [Module] = []
    @Published var present: Present?
    @Published var selection: Module?
    
    private let logger = Logger(module: "ModuleListViewModel")
    
    func load() async {
        do {
            items = try await repository.getModules()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setExample() async {
        do {
            try await repository.create("Module 1", subtitle: "Subtitle 1")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func showAddModule() {
        present = .add
    }
    
    func delete(_ module: Module) async {
        guard let id = module.id else {
            return
        }
        do {
            try await repository.delete(module: id)
            await load()
        } catch {
            logger.error(message: error.localizedDescription)
        }
    }
}

struct ModuleRow: View {
    @ObservedObject var viewModel: Module
    
    var body: some View {
        Text(viewModel.title ?? "")
    }
}

extension ModuleListViewModel {
    enum Present: Identifiable, Hashable {
        case add
        
        var id: Int {
            hashValue
        }
    }
}
