////
////  HeaderView.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 10.09.2023.
////
//
//import SwiftUI
//
//struct HeaderView: View {
//    @ObservedObject var viewModel: HeaderViewModel
//    
//    var body: some View {
//        HStack {
//            Text("Заголовки")
//                .font(.title)
//            Button(action: viewModel.addHeader) {
//                Image(systemName: "plus")
//            }
//            Button(action: viewModel.removeHeaders) {
//                Image(systemName: "minus")
//            }
//        }
//        
//        Table($viewModel.headers, selection: $viewModel.selectedHeader) {
//            TableColumn("Название") { header in
//                TextField("title", text: header.title)
//            }
//            .width(ideal: 150, max: 200)
//            TableColumn("Значение") { header in
//                TextField("value", text: header.value)
//            }
//            .width(ideal: 150, max: 200)
//            
//            TableColumn("Комментарий") { header in
//                TextField("Комментарий", text: header.subtitle)
//            }
//        }
//        .frame(height: headerHeight())
//        .scrollDisabled(true)
//    }
//    
//    func headerHeight() -> CGFloat {
//        CGFloat(viewModel.headers.count) * 25 + 30
//    }
//}
//
//class HeaderViewModel: ObservableObject {
//    @Published var headers: [HeaderModel] = []
//    
//    @Published var selectedHeader = Set<HeaderModel.ID>()
//    
//    let service: Service?
//    
//    init(service: Service? = nil) {
//        headers = [.init(id: UUID(), title: "Content-Type", value: "application/json", subtitle: "")]
//        self.service = service
//    }
//    
//    init(headers: [Header], service: Service? = nil) throws {
//        self.headers = try headers.compactMap(HeaderModel.init)
//        self.service = service
//    }
//    
//    func addHeader() {
//        headers.append(.init(id: UUID(), title: "", value: "", subtitle: ""))
//    }
//    
//    func removeHeaders() {
//        selectedHeader.forEach { id in
//            headers.removeAll {
//                $0.id == id
//            }
//        }
//    }
//}
//
//import Dependencies
//
//final class EditHeaderViewModel: HeaderViewModel {
//    @Dependency(\.persistent) private var store
//    
//    private let hostHeaders: [HeaderModel]
//    private let hostEntity: [Header]
//    
//    private var inserted: [UUID] = []
//    private var deleted: [UUID] = []
//    
//    override init(headers: [Header], service: Service? = nil) throws {
//        self.hostHeaders = try headers.compactMap(HeaderModel.init)
//        self.hostEntity = headers
//        
//        try super.init(headers: headers, service: service)
//    }
//    
//    override func addHeader() {
//        let newHeader = HeaderModel(id: .init(), title: .init(), value: .init(), subtitle: .init(), parentId: service?.id)
//        self.headers.append(newHeader)
//        self.inserted.append(newHeader.id)
//    }
//    
//    override func removeHeaders() {
//        let removed = headers.filter { selectedHeader.contains($0.id) }.map(\.id)
//        deleted += removed
//        super.removeHeaders()
//    }
//    
//    func update() {
//        // Удаление заголовков
//        deleted.forEach { deletedId in
//            if let hostHeader = hostEntity.first(where: { $0.id == deletedId }) {
//                hostHeader.deletedAt = Date()
//            }
//        }
//        
//        // Изменение заголовков
//        headers.forEach { header in
//            if let hostHeader = hostHeaders.first(where: { $0.id == header.id }) {
//                if hostHeader != header {
//                    let entity = getEntity(for: header)
//                    entity?.title = header.title
//                    entity?.subtitle = header.subtitle
//                    entity?.value = header.value
//                    entity?.updatedAt = Date()
//                }
//            }
//        }
//        
//        inserted.forEach { insertedId in
//            if let insertedHeader = headers.first(where: { $0.id == insertedId }) {
//                let entity = Header(context: store.context)
//                entity.id = insertedHeader.id
//                entity.title = insertedHeader.title
//                entity.subtitle = insertedHeader.subtitle
//                entity.value = insertedHeader.value
//                entity.parentId = insertedHeader.parentId
//                entity.createdAt = Date()
//            }
//        }
//        
//        store.save()
//    }
//    
//    private func getEntity(for model: HeaderModel) -> Header? {
//        hostEntity.first { entity in
//            entity.id == model.id
//        }
//    }
//}
