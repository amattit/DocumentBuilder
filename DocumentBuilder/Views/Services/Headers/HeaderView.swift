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
    @Published var headers: [HeaderModel] = [
        .init(id: UUID(), title: "Accept", value: "*/*", subtitle: ""),
        .init(id: UUID(), title: "Authorization", value: "Bearer <token>", subtitle: "Для аутентификации нужен токен"),
        .init(id: UUID(), title: "Content-Type", value: "application/json", subtitle: ""),
    ]
    
    @Published var selectedHeader = Set<HeaderModel.ID>()
}

// TODO: Перенести в CoreData, добавить parentId = service.id
struct HeaderModel: Identifiable {
    var id: UUID
    var title: String
    var value: String
    var subtitle: String
    var parentId: UUID?
}
