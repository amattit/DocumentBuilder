//
//  ModuleItemListView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 05.09.2023.
//

import SwiftUI

struct ModuleItemListView: View {
    @ObservedObject var viewModel: ModuleItemListViewModel
    
    var body: some View {
        List {
            // MARK: - Блок Фич
            ModelItemsSection(
                items: viewModel.features,
                onDeleteAction: viewModel.deleteFeature) { item in
                    Text(item.title ?? "Нет имени")
                } addActionView: {
                    HStack {
                        Button(action: viewModel.addFeature) {
                            Image(systemName: "plus")
                        }
                        Text("Фичи")
                            .font(.largeTitle)
                    }
                }
            
            // MARK: - Блок сервисов
            ModelItemsSection(
                items: viewModel.services,
                onDeleteAction: viewModel.deleteService) { item in
                    ServiceRowView(service: item)
                } addActionView: {
                    HStack {
                        Button(action: viewModel.addService) {
                            Image(systemName: "plus")
                        }
                        Text("Сервисы")
                            .font(.largeTitle)
                    }
                }
            
            // MARK: - Блок Моделей данных
            ModelItemsSection(
                items: viewModel.models,
                onDeleteAction: viewModel.deleteModel) { item in
                    Text(item.title ?? "undefind")
                } addActionView: {
                    HStack {
                        Button(action: viewModel.addDataModel) {
                            Image(systemName: "plus")
                        }
                        Text("Модели данных")
                            .font(.largeTitle)
                    }
                }
        }
        .navigationDestination(for: Feature.self, destination: { feature in
            FeatureView(viewModel: .init(feature: feature))
        })
        .sheet(item: $viewModel.present, content: { item in
            switch item {
            case .addModel:
                VStack {
                    Text("Добавить \(item.title)")
                }
                .frame(minWidth: 300, minHeight: 400)
            case .addFeature:
                AddFeatureView(viewModel: .init(moduleId: viewModel.module.id, onSave: {
                    viewModel.present = nil
                }))
            case .addService:
                AddServiceView(viewModel: .init(module: viewModel.module))
                .frame(minWidth: 600, minHeight: 700)
            }
        })
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    ForEach(ModuleItemListViewModel.Present.allCases) { item in
                        Button(action: {
                            viewModel.present(item)
                        }) {
                            HStack {
                                Image(systemName: item.iconName)
                                Text(item.title)
                            }
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .menuStyle(.borderlessButton)
            }
        }
    }
}

struct ModelItemsSection<Data, Content, AddContent>: View where Data: RandomAccessCollection, Data.Element: Identifiable, Content: View, Data.Element: Hashable, AddContent: View {
    let items: Data
    let onDeleteAction: (IndexSet) -> Void
    let itemView: (Data.Element) -> Content
    let addActionView: () -> AddContent
    
    var body: some View {
        Section {
            ForEach(items) { model in
                NavigationLink(value: model) {
                    itemView(model)
                }
            }
            .onDelete(perform: onDeleteAction)
        } header: {
            addActionView()
        }
    }
}

struct ModuleItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ModuleItemListView(viewModel: .init(module: .preview))
    }
}

