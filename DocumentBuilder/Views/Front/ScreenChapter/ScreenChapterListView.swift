//
//  ScreenListView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 20.09.2023.
//

import SwiftUI
import Dependencies
import Combine

struct ScreenChapterListView: View {
    @ObservedObject var viewModel: ScreenChapterListViewModel
    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                NavigationLink(value: item) {
                    Text(item.title)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    viewModel.present = .addChapter
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(item: $viewModel.present) { item in
            switch item {
            case .addChapter:
                CreateScreenChapterView(viewModel: CreateScreenChapterViewModel(onSave: {
                    viewModel.present = nil
                }))
            }
        }
    }
}

struct ScreenChapterListView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenChapterListView(viewModel: .init())
    }
}


final class ScreenChapterListViewModel: ObservableObject {
    enum Present: Identifiable, Hashable {
        case addChapter
        
        var id: Int {
            hashValue
        }
    }
    @Dependency(\.screenChapterRepository) var repository
    
    @Published var items: [ScreenChapterModel] = []
    @Published var selected: ScreenChapterModel?
    @Published var present: Present?
    
    private var disposables = Set<AnyCancellable>()
    
    init() {
        bind()
        load()
    }
    
    func load() {
        do {
            self.items = try repository.getScreenChapters().compactMap {
                guard let id = $0.id else { return nil }
                return ScreenChapterModel(id: id, title: $0.title ?? "", managedObject: $0)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func bind() {
        NotificationCenter.default.publisher(for: NSManagedObjectContext.didSaveObjectsNotification)
            .sink { notification in
                self.load()
            }
            .store(in: &disposables)
    }
}
