////
////  QueryParametersView.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 10.09.2023.
////
//
//import SwiftUI
//
//struct QueryParametersView: View {
//    @ObservedObject var viewModel: QueryParametersViewModel
//    
//    var body: some View {
//        HStack {
//            Text("Query параметры")
//                .font(.title)
//            Button(action: viewModel.add) {
//                Image(systemName: "plus")
//            }
//            Button(action: viewModel.remove) {
//                Image(systemName: "minus")
//            }
//        }
//        
//        Table($viewModel.parameters, selection: $viewModel.selected) {
//            TableColumn("Название") { header in
//                TextField("Название", text: header.title)
//            }
//            .width(ideal: 150, max: 200)
//            
//            TableColumn("Тип") { header in
//                TextField("Тип", text: header.type)
//            }
//            .width(ideal: 150, max: 200)
//            
//            TableColumn("О/Н") { header in
//                Toggle("", isOn: header.isRequired)
//            }
//            .width(ideal: 30, max: 30)
//            
//            TableColumn("Комментарий") { header in
//                TextField("Комментарий", text: header.comment, axis: .vertical)
//            }
//        }
//        .frame(height: headerHeight())
//        .scrollDisabled(true)
//    }
//    
//    func headerHeight() -> CGFloat {
//        CGFloat(viewModel.parameters.count) * 25 + 30
//    }
//}
//
//struct QueryParametersView_Previews: PreviewProvider {
//    static var previews: some View {
//        QueryParametersView(viewModel: .init())
//    }
//}
//
//class QueryParametersViewModel: ObservableObject {
//    @Published var parameters: [ModelAttribute] = []
//    @Published var selected = Set<ModelAttribute.ID>()
//    
//    let service: Service?
//    
//    init(service: Service? = nil) {
//        self.service = service
//    }
//    
//    init(query: [QueryAttributes], service: Service? = nil) throws {
//        self.service = service
//        parameters = try query.compactMap(ModelAttribute.init)
//    }
//    
//    func add() {
//        parameters.append(.init(id: .init(), title: .init(), type: .init(), isRequired: false, comment: .init(), parentId: .init()))
//    }
//    
//    func remove() {
//        selected.forEach { item in
//            parameters.removeAll {
//                $0.id == item
//            }
//        }
//    }
//}
//
//import Dependencies
//
//class EditQueryParametersViewModel: QueryParametersViewModel {
//    @Dependency(\.persistent) private var store
//    
//    private let hostQuery: [ModelAttribute]
//    private let hostEntity: [QueryAttributes]
//    
//    private var inserted: [UUID] = []
//    private var deleted: [UUID] = []
//    
//    override init(query: [QueryAttributes], service: Service? = nil) throws {
//        self.hostQuery = try query.compactMap(ModelAttribute.init)
//        self.hostEntity = query
//        
//        try super.init(query: query, service: service)
//    }
//    
//    override func add() {
//        let newQuery = ModelAttribute(id: .init(), title: .init(), type: .init(), isRequired: false, comment: .init(), parentId: service?.id)
//        self.parameters.append(newQuery)
//        self.inserted.append(newQuery.id)
//    }
//    
//    override func remove() {
//        let removed = parameters.filter { selected.contains($0.id) }.map(\.id)
//        deleted += removed
//        super.remove()
//    }
//    
//    func update() {
//        // Удаление query параметров
//        deleted.forEach { deletedId in
//            if let hostHeader = hostEntity.first(where: { $0.id == deletedId }) {
//                hostHeader.deletedAt = Date()
//            }
//        }
//        
//        // Изменение query параметров
//        parameters.forEach { parameter in
//            if let hostHeader = hostQuery.first(where: { $0.id == parameter.id }) {
//                if hostHeader != parameter {
//                    let entity = getEntity(for: parameter)
//                    entity?.title = parameter.title
//                    entity?.objectType = parameter.type
//                    entity?.isRequired = parameter.isRequired
//                    entity?.comment = parameter.comment
//                    entity?.updatedAt = Date()
//                }
//            }
//        }
//        
//        // Добавление query параметров
//        inserted.forEach { insertedId in
//            if let insertedQuery = parameters.first(where: { $0.id == insertedId }) {
//                let entity = QueryAttributes(context: store.context)
//                entity.id = insertedQuery.id
//                entity.parentId = insertedQuery.parentId
//                entity.title = insertedQuery.title
//                entity.comment = insertedQuery.comment
//                entity.isRequired = insertedQuery.isRequired
//                entity.objectType = insertedQuery.type
//                entity.createdAt = Date()
//            }
//        }
//        
//        store.save()
//    }
//    
//    private func getEntity(for model: ModelAttribute) -> QueryAttributes? {
//        hostEntity.first { entity in
//            entity.id == model.id
//        }
//    }
//}
