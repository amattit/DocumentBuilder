//
//  DataModelListView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 11.09.2023.
//

import SwiftUI
import Dependencies

struct DataModelListView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DataModelListViewModel
    var body: some View {
        List() {
            ForEach(viewModel.models) { model in
                Button(action: {
                    viewModel.select(model: model)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    ModelRowView(model: model)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background { viewModel.selected == model ? Color.blue : .clear }
                }
                .buttonStyle(.borderless)
            }
        }
    }
}

struct DataModelListView_Previews: PreviewProvider {
    static var previews: some View {
        DataModelListView(viewModel: .init(module: .preview))
    }
}

import Combine

final class DataModelListViewModel: ObservableObject {
    @Dependency(\.dataModelRepository) private var repository
    
    @Published var models: [DataModel] = []
    @Published var selected: DataModel?
    let publisher = PassthroughSubject<Bool, Never>()
    let module: Module
    
    init(module: Module) {
        self.module = module
        getModels()
    }
    
    func getModels() {
        do {
            self.models = try repository.getDataModels(for: module)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func select(model: DataModel) {
        self.selected = model
        publisher.send(true)
    }
}
