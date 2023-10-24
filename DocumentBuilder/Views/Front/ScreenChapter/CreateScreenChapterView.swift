//
//  CreateScreenChapterView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 27.09.2023.
//

import SwiftUI
import Dependencies

struct CreateScreenChapterView<ViewModel: CreateScreenProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            TextField("Введите название раздела", text: $viewModel.title, axis: .vertical)
            Button("Сохранить") {
                viewModel.create()
            }
        }
        .frame(minWidth: 300, minHeight: 300)
    }
}

final class CreateScreenChapterViewModel: CreateScreenProtocol {
    @Dependency(\.screenChapterRepository) var repository
    
    @Published var title: String = ""
    let onSave: () -> Void
    
    init(onSave: @escaping () -> Void) {
        self.onSave = onSave
    }
    
    func create() {
        let item = ScreenChapterModel(id: UUID(), title: title)
        do {
            try repository.createScreenChapter(from: item)
            onSave()
        } catch {
            print(error.localizedDescription)
        }
    }
}

protocol CreateScreenProtocol: ObservableObject {
    func create()
    var title: String { get set }
}

final class CreateScreenViewModel: CreateScreenProtocol {
    @Dependency(\.screenRepository) var repository
    
    @Published var title: String = ""
    let onSave: () -> Void
    let chapter: ScreenChapterModel
    let type: ScreenModel.ScreenType
    
    init(chaper: ScreenChapterModel, type: ScreenModel.ScreenType, onSave: @escaping () -> Void) {
        self.chapter = chaper
        self.type = type
        self.onSave = onSave
    }
    
    func create() {
        let item = ScreenModel(id: UUID(), parentId: chapter.id, title: title, type: type)
        do {
            try repository.createScreen(from: item)
            onSave()
        } catch {
            print(error.localizedDescription)
        }
    }
}
