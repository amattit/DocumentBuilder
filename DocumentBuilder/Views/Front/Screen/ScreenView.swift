////
////  ScreenView.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 19.09.2023.
////
//
//import Foundation
//import SwiftUI
//
//struct ScreenView: View {
//    @ObservedObject var viewModel: ScreenViewModel
//
//    var body: some View {
//        HSplitView {
//            // Основной контент
//            ScrollView {
//                SelectedState
//                TitleView
//            }
//            // Вспомогательный контент
//            VStack(alignment: .leading) {
//                TypeView
//                Text("Действия")
//                Button(action: viewModel.showAddState) {
//                    Text("Добавить состояние")
//                }
//                .buttonStyle(.link)
//                
//                Button(action: {}) {
//                    Text("Добавить модель экрана")
//                }
//                .buttonStyle(.link)
//                
//                Button(action: viewModel.showAddScreen) {
//                    Text("Добавить экран")
//                }
//                .buttonStyle(.link)
//                
//                Button(action: viewModel.showAddWidget) {
//                    Text("Добавить виджет")
//                }
//                .buttonStyle(.link)
//                Spacer()
//            }
//            .padding()
//        }
//        .sheet(item: $viewModel.present) { item in
//            switch item {
//            case .addState:
//                AddScreenStateView(viewModel: AddScreenStateViewModel(screenModel: viewModel.item))
//                    .frame(minWidth: 500, minHeight: 500)
//            case .addScreen:
//                CreateScreenChapterView(viewModel: CreateScreenViewModel(
//                    chaper: viewModel.chapter,
//                    type: .screen,
//                    onSave: { viewModel.present = nil }
//                )
//)
//            case .addWidget:
//                CreateScreenChapterView(viewModel: CreateScreenViewModel(
//                    chaper: viewModel.chapter,
//                    type: .widget,
//                    onSave: { viewModel.present = nil }
//                )
//)
//            }
//        }
//    }
//    
//    var TitleView: some View {
//        TextField("Название экрана", text: $viewModel.item.title)
//            .font(.largeTitle)
//            .textFieldStyle(.plain)
//    }
//    
//    var TypeView: some View {
//        HStack {
//            Text("Тип экрана:")
//            Text(viewModel.item.type.rawValue)
//        }
//    }
//    
//    @ViewBuilder
//    var SelectedState: some View {
//        TabView {
//            ForEach(viewModel.states) { item in
//                ScreenStateView(viewModel: .init(state: item))
//                    .tabItem {
//                        Text(item.state)
//                    }
//            }
//        }
//    }
//}
//
//import Dependencies
//
//final class ScreenViewModel: ObservableObject {
//    @Dependency(\.persistent) var store
//    
//    @Published var item: ScreenModel
//    @Published var states: [ScreenStateModel] = []
//    @Published var selectedState: ScreenStateModel?
//    @Published var present: Present?
//    let chapter: ScreenChapterModel
//    
//    init(item: ScreenModel, chapter: ScreenChapterModel) {
//        self.item = item
//        self.chapter = chapter
//        load()
//    }
//    
//    func load() {
//        do {
//            let request = ScreenState.fetchRequest()
//            request.predicate = NSPredicate(format: "parentId == %@", item.id.uuidString)
//            request.sortDescriptors = [
//                NSSortDescriptor(keyPath: \ScreenState.createdAt, ascending: true)
//            ]
//            self.states = try store.context.fetch(request).compactMap({ screenState in
//                guard let id = screenState.id, let parentId = screenState.parentId else { return nil }
//                return ScreenStateModel(id: id, parentId: parentId, state: screenState.state ?? "N/A", layoutLink: screenState.layoutLink ?? "N/a")
//            })
//            self.selectedState = states.first
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//    }
//    
//    func select(_ state: ScreenStateModel) {
//        self.selectedState = state
//    }
//    
//    func showAddState() {
//        present = .addState
//    }
//    
//    func showAddScreen() {
//        present = .addScreen
//    }
//    
//    func showAddWidget() {
//        present = .addWidget
//    }
//}
//
//extension ScreenViewModel {
//    enum Present: Identifiable, Hashable {
//        case addState
//        case addScreen
//        case addWidget
//        
//        var id: Int {
//            self.hashValue
//        }
//    }
//}
