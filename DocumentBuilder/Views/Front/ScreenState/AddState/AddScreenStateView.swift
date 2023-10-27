////
////  AddScreenStateView.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 22.10.2023.
////
//
//import SwiftUI
//
//struct AddScreenStateView: View {
//    @ObservedObject var viewModel: AddScreenStateViewModel
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            VStack(alignment: .leading, spacing: 4, content: {
//                TextField("Состояние", text: $viewModel.state)
//                
//                HStack {
//                    ForEach(viewModel.defaultStates, id: \.self) { item in
//                        Button(action: {
//                            viewModel.state = item
//                        }) {
//                            Text(item)
//                        }
//                        .buttonStyle(.link)
//                    }
//                }
//            })
//            
//            TextField("Ссылка на макет", text: $viewModel.layoutLink)
//                .onSubmit() {
//                    Task {
//                        try await viewModel.loadPreview()
//                    }
//                }
//            
//            image
//            
//            Button(action: viewModel.create) {
//                Text("Сохранить")
//            }
//
//        }
//        .padding()
//    }
//    
//    @ViewBuilder
//    var image: some View {
//        if let data = viewModel.data, let nsImage = NSImage(data: data) {
//            Image(nsImage: nsImage)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .padding()
//                .background(Color.white)
//                .frame(maxWidth: 600)
//        }
//    }
//}
//
//import Dependencies
//
//final class AddScreenStateViewModel: ObservableObject {
//    @Dependency(\.persistent) var store
//    @Dependency(\.figma) var figma
//    
//    @Published var layoutLink = ""
//    @Published var state = ""
//    @Published var data: Data?
//    
//    let defaultStates = ScreenStateModel.recommendedStates
//    let screenModel: ScreenModel
//    
//    init(screenModel: ScreenModel) {
//        self.screenModel = screenModel
//    }
//    
//    func create() {
//        let state = ScreenState(context: store.context)
//        state.id = UUID()
//        state.parentId = screenModel.id
//        state.state = self.state
//        state.createdAt = Date()
//        state.updatedAt = Date()
//        state.layoutLink = self.layoutLink
//        
//        store.save()
//    }
//    
//    @MainActor
//    func loadPreview() async throws {
//        let figmaResponse = try await figma.getImageUrl(from: layoutLink)
//        guard let imageRef = figmaResponse.images.first?.value, let _ = URL(string: imageRef) else { throw Error.badUrl }
//        
//        data = try await figma.loadData(imageRef)
//    }
//}
