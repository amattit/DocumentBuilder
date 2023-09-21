//
//  ScreenListView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 20.09.2023.
//

import SwiftUI

struct ScreenChapterListView: View {
    @ObservedObject var viewModel: ScreenListViewModel
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


final class ScreenListViewModel: ObservableObject {
    @Published var items: [ScreenChapterModel] = []
}
