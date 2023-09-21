//
//  ScreenView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 17.09.2023.
//

import SwiftUI

struct ScreenChapterView: View {
    @State var screens: [String] = (0...5).map { "Screen \($0)"}
    @ObservedObject var viewModel: ScreenChapterViewModel
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(screens) {
                    Text($0)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        print("add screen")
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        } detail: {
            NavigationSplitView {
                List {
                    ForEach(viewModel.states) { state in
                        Button(state.state) {
                            viewModel.selected = state
                        }
                    }
                    Button("Добавить экран") {
                        print("add state")
                    }
                }
            } detail: {
                if let selected = viewModel.selected {
                    ScreenView(viewModel: .init(state: selected))
                }
            }
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

final class ScreenChapterViewModel: ObservableObject {
    @Published var states = ScreenStateModel.mock
    @Published var selected: ScreenStateModel?
}
