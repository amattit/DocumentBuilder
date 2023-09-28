//
//  ScreenListView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 20.09.2023.
//

import SwiftUI

struct ScreenChapterListView: View {
    @ObservedObject var viewModel: ScreenChapterListViewModel
    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                Text(item.title)
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
    @Published var items: [ScreenChapterModel] = []
    
    init() {
        load()
    }
    
    func load() {
        self.items = (0..<10).map {
            .init(id: .init(), title: "Chapter \($0)")
        }
    }
}
