////
////  AddModuleView.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 04.09.2023.
////
//
//import SwiftUI
//import Dependencies
//
//struct AddModuleView: View {
//    
//    @ObservedObject var viewModel: AddModuleViewModel
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Spacer()
//                Button(action: viewModel.save) {
//                    Text("Сохранить")
//                }
//                .buttonStyle(.link)
//            }
//            TextField("Название модуля", text: $viewModel.title)
//            TextEditor(text: $viewModel.subtitle)
//        }
//        .padding(16)
//        .frame(minWidth: 300, minHeight: 200)
//    }
//}
//
//final class AddModuleViewModel: ObservableObject {
//    @Dependency(\.persistent) var persistent
//    
//    @Published var title = ""
//    @Published var subtitle = ""
//    
//    private let onSave: () -> Void
//    
//    init(onSave: @escaping () -> Void) {
//        self.onSave = onSave
//    }
//    
//    func save() {
//        let module = Module(context: persistent.context)
//        module.title = title
//        module.subtitle = subtitle
//        module.id = UUID()
//        module.createdAt = Date()
//        
//        do {
//            try persistent.context.save()
//            onSave()
//        } catch {
//            title = error.localizedDescription
//            print(error.localizedDescription)
//        }
//    }
//}
