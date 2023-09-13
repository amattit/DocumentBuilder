//
//  DataModelView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 09.09.2023.
//

import SwiftUI
import Dependencies

struct DataModelView: View {
    @ObservedObject var viewModel: DataModelViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            TextField("Название модели", text: $viewModel.model.title)
                .font(.largeTitle)
                .textFieldStyle(.plain)
                .padding(.horizontal)
            
            HStack {
                Text("Аттрибуты")
                Button(action: {
                    viewModel.addAttribute()
                }) {
                    Image(systemName: "plus")
                }
                Button(action: {
                    viewModel.selectedAttributes.forEach { id in
                        viewModel.attributes.removeAll {
                            $0.id == id
                        }
                    }
                }) {
                    Image(systemName: "minus")
                }
            }
            .padding(.horizontal)
            
            Table($viewModel.attributes, selection: $viewModel.selectedAttributes) {
                TableColumn("Название") { attribute in
                    TextField("название", text: attribute.title)
                }
                .width(ideal: 150, max: 200)
                
                TableColumn("Тип данных") { attribute in
                    TextField("Тип", text: attribute.type)
                }
                .width(ideal: 150, max: 200)
                
                TableColumn("О/Н") { attribute in
                    Toggle("", isOn: attribute.isRequired)
                }
                .width(ideal: 30, max: 30)
                
                TableColumn("Комментарий") { attribute in
                    HStack {
                        TextField("Комментарий", text: attribute.comment)
                        Button(action: { viewModel.setPopover(model: attribute.wrappedValue) }) {
                            Image(systemName: "info.circle.fill")
                        }
                    }
                }
            }
            .popover(item: $viewModel.popover) { info in
                VStack {
                    Text(info)
                }
            }
            .frame(height: requestModelHeight())
            .scrollDisabled(true)
        }
    }
    
    func requestModelHeight() -> CGFloat {
        CGFloat(viewModel.attributes.count) * 28 + 30
    }
}

struct DataModelView_Previews: PreviewProvider {
    static var previews: some View {
        DataModelView(viewModel: .init(type: .plain))
    }
}

/// Абстрактный класс для DataModelView
class DataModelViewModel: ObservableObject {
    @Dependency(\.persistent) var store
    
    @Published var model: Model = .init(id: UUID(), title: "", subtitle: "")
    @Published var attributes: [ModelAttribute] = []
    @Published var selectedAttributes = Set<ModelAttribute.ID>()
    @Published var popover: String?
    let modelType: ModelType
    
    /// init для превью
    init(type: ModelType) {
        self.modelType = type
    }
    
    init(dataMode: DataModel, attributes: [DataModelAttributes]) {
        self.model = .init(
            id: dataMode.id ?? UUID(),
            title: dataMode.title ?? "",
            subtitle: dataMode.subtitle ?? ""
        )
        
        self.attributes = attributes.compactMap { item -> ModelAttribute? in
            guard let id = item.id, let parentId = item.parentId else { return nil }
            return .init(
                id: id,
                title: item.title ?? "",
                type: item.objectType ?? "",
                isRequired: item.isRequired,
                comment: item.comment ?? "",
                parentId: parentId
            )
        }
        
        modelType = .network
    }
    
    func addAttribute() {
        attributes.append(.init(id: .init(), title: "", type: "", isRequired: false, comment: "", parentId: model.id))
    }
    
    func removeAttributes() {
        selectedAttributes.forEach { id in attributes.removeAll { $0.id == id } }
    }
    
    func setPopover(model: ModelAttribute) {
        popover = model.comment
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
}
