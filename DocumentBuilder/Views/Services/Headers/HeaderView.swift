//
//  HeaderView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 10.09.2023.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewModel: HeaderViewModel
    
    var body: some View {
        HStack {
            Text("Заголовки")
                .font(.title)
            Button(action: {
                viewModel.headers.append(.init(id: UUID(), title: "", value: "", subtitle: ""))
            }) {
                Image(systemName: "plus")
            }
            Button(action: {
                viewModel.selectedHeader.forEach { id in
                    viewModel.headers.removeAll {
                        $0.id == id
                    }
                }
            }) {
                Image(systemName: "minus")
            }
        }
        
        Table($viewModel.headers, selection: $viewModel.selectedHeader) {
            TableColumn("Название") { header in
                TextField("title", text: header.title)
            }
            .width(ideal: 150, max: 200)
            TableColumn("Значение") { header in
                TextField("value", text: header.value)
            }
            .width(ideal: 150, max: 200)
            
            TableColumn("Комментарий") { header in
                TextField("Комментарий", text: header.subtitle)
            }
        }
        .frame(height: headerHeight())
        .scrollDisabled(true)
    }
    
    func headerHeight() -> CGFloat {
        CGFloat(viewModel.headers.count) * 25 + 30
    }
}

final class HeaderViewModel: ObservableObject {
    @Published var headers: [HeaderModel] = []
    
    @Published var selectedHeader = Set<HeaderModel.ID>()
    
    init() {
        headers = [.init(id: UUID(), title: "Content-Type", value: "application/json", subtitle: "")]
    }
    
    init(headers: [Header]) {
        self.headers = headers.compactMap { item -> HeaderModel? in
            guard let id = item.id else { return nil }
            return .init(id: id, title: item.title ?? "", value: item.value ?? "", subtitle: item.subtitle ?? "")
        }
    }
}

// TODO: Перенести в CoreData, добавить parentId = service.id
struct HeaderModel: Identifiable {
    var id: UUID
    var title: String
    var value: String
    var subtitle: String
    var parentId: UUID?
}
