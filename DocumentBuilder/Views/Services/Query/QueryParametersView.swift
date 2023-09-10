//
//  QueryParametersView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 10.09.2023.
//

import SwiftUI

struct QueryParametersView: View {
    @ObservedObject var viewModel: QueryParametersViewModel
    
    var body: some View {
        HStack {
            Text("Query параметры")
                .font(.title)
            Button(action: viewModel.add) {
                Image(systemName: "plus")
            }
            Button(action: viewModel.remove) {
                Image(systemName: "minus")
            }
        }
        
        Table($viewModel.parameters, selection: $viewModel.selected) {
            TableColumn("Название") { header in
                TextField("Название", text: header.title)
            }
            .width(ideal: 150, max: 200)
            
            TableColumn("Тип") { header in
                TextField("Тип", text: header.type)
            }
            .width(ideal: 150, max: 200)
            
            TableColumn("О/Н") { header in
                Toggle("", isOn: header.isRequired)
            }
            .width(ideal: 30, max: 30)
            
            TableColumn("Комментарий") { header in
                TextField("Комментарий", text: header.comment)
            }
        }
        .frame(height: headerHeight())
        .scrollDisabled(true)
    }
    
    func headerHeight() -> CGFloat {
        CGFloat(viewModel.parameters.count) * 25 + 30
    }
}

struct QueryParametersView_Previews: PreviewProvider {
    static var previews: some View {
        QueryParametersView(viewModel: .init())
    }
}

class QueryParametersViewModel: ObservableObject {
    @Published var parameters: [ModelAttribute] = []
    @Published var selected = Set<ModelAttribute.ID>()
    
    func add() {
        parameters.append(.init(id: .init(), title: .init(), type: .init(), isRequired: false, comment: .init(), parentId: .init()))
    }
    
    func remove() {
        selected.forEach { item in
            parameters.removeAll {
                $0.id == item
            }
        }
    }
}
