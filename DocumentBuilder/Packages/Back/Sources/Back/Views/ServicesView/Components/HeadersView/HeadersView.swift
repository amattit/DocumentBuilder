//
//  File.swift
//  
//
//  Created by Михаил Серегин on 27.10.2023.
//

import SwiftUI

struct HeadersView: View {
    @Binding var items: [HeaderModel]
    @Binding var selection: Set<HeaderModel.ID>
    var body: some View {
        VStack {
            HStack {
                Text("Заголовки")
                Button(action: addItem) {
                    Image(systemName: "plus")
                }
                Button(action: deleteItems) {
                    Image(systemName: "minus")
                }
            }
            Table($items, selection: $selection) {
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
    }
    
    func addItem() {
        items.append(.init(id: .init(), title: "", value: "", subtitle: ""))
    }
    
    func deleteItems() {
        selection.forEach { id in
            items.removeAll { $0.id == id }
        }
    }
    
    func headerHeight() -> CGFloat {
        CGFloat(items.count) * 25 + 30
    }
}

extension HeadersView {
    struct HeaderModel: Identifiable, Hashable {
        var id: UUID
        var title: String
        var value: String
        var subtitle: String
        var parentId: UUID?
    }
}
