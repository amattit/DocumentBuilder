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
        DataModelView(viewModel: .init())
    }
}

class CreateNetworkDataModelViewModel: DataModelViewModel {
    let service: Service
    
    init(service: Service) {
        self.service = service
        super.init()
        model = .init(id: UUID(), title: "", subtitle: "", type: .network)
    }
    
    override func save() {
        
        let dataModel = DataModel(context: store.context)
            dataModel.id = model.id
            dataModel.title = model.title
            dataModel.subtitle = model.subtitle
            dataModel.createdAt = Date()
            dataModel.parentId = service.id
            dataModel.modelType = model.type.rawValue
        
        
        let _ = self.attributes.map {
            let attribute = DataModelAttributes(context: store.context)
            attribute.id = $0.id
            attribute.parentId = dataModel.id
            attribute.title = $0.title
            attribute.createdAt = Date()
            attribute.comment = $0.comment
            attribute.isRequired = $0.isRequired
            attribute.objectType = $0.type
            return attribute
        }
        
        store.save()
    }
}

/// Абстрактный класс для DataModelView
class DataModelViewModel: ObservableObject {
    @Dependency(\.persistent) var store
    
    @Published var model: Model = .empty
    @Published var attributes: [ModelAttribute] = []
    @Published var selectedAttributes = Set<ModelAttribute.ID>()
    @Published var popover: String?
    
    /// init для превью
    init() {}
    
    func addAttribute() {
        attributes.append(.init(id: .init(), title: "", type: "", isRequired: false, comment: "", parentId: model.id))
    }
    
    func removeAttributes() {
        selectedAttributes.forEach { id in attributes.removeAll { $0.id == id } }
    }
    
    func setPopover(model: ModelAttribute) {
        popover = model.comment
    }
    
    func save() {}
}

extension String: Identifiable {
    public var id: String {
        self
    }
}
