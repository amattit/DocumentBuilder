////
////  ScreenListView.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 22.09.2023.
////
//
//import SwiftUI
//import Dependencies
//import Combine
//
//struct ScreenListView: View {
//    @ObservedObject var viewModel: ScreenListViewModel
//    
//    var body: some View {
//        List {
//            ForEach(viewModel.sections) { item in
//                Section(item.title) {
//                    ForEach(viewModel.items(for: item)) { item in
//                        NavigationLink(value: item) {
//                            Text(item.title)
//                        }
//
//                    }
//                }
//            }
//        }
//        .toolbar {
//            ToolbarItem {
//                Button(action: {
//                    viewModel.present = .addScreen
//                }) {
//                    Image(systemName: "plus")
//                }
//            }
//            
//            ToolbarItem {
//                Button(action: {
//                    viewModel.present = .addComponent
//                }) {
//                    Image(systemName: "plus.app")
//                }
//            }
//        }
//        .sheet(item: $viewModel.present) { item in
//            switch item {
//            case .addScreen:
//                CreateScreenChapterView(
//                    viewModel: CreateScreenViewModel(
//                        chaper: viewModel.chapter,
//                        type: .screen,
//                        onSave: { viewModel.present = nil }
//                    )
//                )
//            case .addComponent:
//                CreateScreenChapterView(
//                    viewModel: CreateScreenViewModel(
//                        chaper: viewModel.chapter,
//                        type: .widget,
//                        onSave: { viewModel.present = nil }
//                    )
//                )
//            }
//        }
//    }
//}
//
//#Preview {
//    ScreenListView(viewModel: .init(chapter: .init(id: UUID(), title: "Chapter")))
//}
//
//final class ScreenListViewModel: ObservableObject {
//    
//    enum Present: Identifiable, Hashable {
//        case addScreen
//        case addComponent
//        
//        var id: Int {
//            hashValue
//        }
//    }
//    
//    @Dependency(\.screenRepository) var repository
//    
//    @Published var items: [ScreenModel] = []
//    @Published var selected: ScreenModel?
//    @Published var present: Present?
//    
//    var sections: [ScreenModel.ScreenType] {
//        Array(Set(items.map(\.type)))
//            .sorted(by: ScreenModel.ScreenType.priorityDescriptor)
//    }
//    
//    let chapter: ScreenChapterModel
//    private var disposables = Set<AnyCancellable>()
//    
//    init(chapter: ScreenChapterModel) {
//        self.chapter = chapter
//        bind()
//        load()
//    }
//    
//    func load() {
//        do {
//            self.items = try repository.getScreens(for: chapter).compactMap {
//                guard let id = $0.id, let parentId = $0.parentId else { return nil }
//                return ScreenModel(id: id, parentId: parentId, title: $0.title ?? "", type: .init(rawValue: $0.type ?? "") ?? .screen, managedObject: $0)
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func items(for section: ScreenModel.ScreenType) -> [ScreenModel] {
//        items.filter {
//            $0.type == section
//        }
//    }
//    
//    private func bind() {
//        NotificationCenter.default.publisher(for: NSManagedObjectContext.didSaveObjectsNotification)
//            .sink { notification in
//                self.load()
//            }
//            .store(in: &disposables)
//    }
//}
