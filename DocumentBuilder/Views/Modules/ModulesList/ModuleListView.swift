////
////  ModuleListView.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 04.09.2023.
////
//
//import SwiftUI
//
//struct ModuleListView: View {
//    @ObservedObject var viewModel: ModuleListViewModel
//    
//    var body: some View {
//        List(selection: $viewModel.selected) {
//            ForEach(viewModel.modules) { module in
//                Button(action: {
//                    viewModel.selected = module
//                }) {
//                    ModuleRowView(module: module)
//                        .background {
//                            viewModel.selected == module ? Color.blue.opacity(0.5) : .clear
//                        }
//                }
//                .buttonStyle(.borderless)
//            }
//        }
//        .onAppear {
//            viewModel.load()
//        }
//        .toolbar {
//            ToolbarItem(placement: .primaryAction) {
//                Button(action: viewModel.addModule) {
//                    Image(systemName: "plus")
//                }
//            }
//            ToolbarItem(placement: .primaryAction) {
//                Button(action: {
//                    guard let module = viewModel.selected else { return }
//                    viewModel.delete(module)
//                }) {
//                    Image(systemName: "trash")
//                }
//            }
//        }
//        .sheet(item: $viewModel.present) { item in
//            switch item {
//            case .addModule:
//                AddModuleView(viewModel: .init(onSave: {
//                    viewModel.present = nil
//                }))
//            }
//        }
//    }
//}
//
//struct ModuleRowView: View {
//    let module: Module
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(title)
//                    .font(.body)
//                    .multilineTextAlignment(.leading)
//                    .lineLimit(3)
//                Text(subtitle)
//                    .font(.footnote)
//                    .multilineTextAlignment(.leading)
//                    .lineLimit(2)
//            }
//            Spacer()
//        }
//        .padding(.horizontal, 8)
//        .padding(.vertical, 4)
//    }
//    
//    var title: String {
//        module.title.nilIfEmpty ?? "Имя модуля"
//    }
//    
//    var subtitle: String {
//        module.subtitle.nilIfEmpty ?? "Добавте описание"
//    }
//}
