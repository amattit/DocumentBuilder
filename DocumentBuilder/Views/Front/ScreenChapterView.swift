//
//  ScreenView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 17.09.2023.
//

import SwiftUI

struct ScreenChapterView: View {
    @ObservedObject var viewModel: ScreenChapterListViewModel
    
    var body: some View {
        NavigationSplitView {
            ScreenChapterListView(viewModel: viewModel)
                .navigationDestination(for: ScreenChapterModel.self, destination: { item in
                    NavigationSplitView {
                        ScreenListView(viewModel: .init(chapter: item))
                            .navigationDestination(for: ScreenModel.self) { item in
                                ScreenView(viewModel: .init(item: item))
                            }
                    } detail: {
                        Text("Выберите экран")
                    }
                })
        } detail: {
            Text("Выберите модуль")
        }
        .frame(minWidth: 600, minHeight: 600)
    }
}

struct ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenChapterView(viewModel: .init())
    }
}

class ScreenStateOld: Identifiable, Hashable {
    static func == (lhs: ScreenStateOld, rhs: ScreenStateOld) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    let id: String
    let state: String
    var title: String
    var image: NSImage?
    var url: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(state)
        hasher.combine(image)
    }
    
    init(id: String, state: String, image: NSImage? = nil) {
        self.id = id
        self.state = state
        self.title = ""
        self.url = ""
        self.image = image
    }
}

extension ScreenStateOld {
    static var mock: [ScreenStateOld] = [
        .init(id: "1", state: "State 1"),
        .init(id: "2", state: "State 2"),
        .init(id: "3", state: "State 3"),
        .init(id: "4", state: "State 4"),
        .init(id: "5", state: "State 5"),
    ]
}

extension ScreenStateModel {
    static var mock: [ScreenStateModel] = [
        .init(id: .init(), parentId: .init(), state: "full", layoutLink: "")
    ]
}
