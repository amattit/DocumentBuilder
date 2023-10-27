////
////  DataModelView.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 09.09.2023.
////
//
//import SwiftUI
//import Dependencies
//
//struct DataModelView: View {
//    @ObservedObject var viewModel: DataModelViewModel
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            TextField("Название модели", text: $viewModel.model.title)
//                .font(.largeTitle)
//                .textFieldStyle(.plain)
//                .padding(.horizontal)
//            
//            HStack {
//                Text("Аттрибуты")
//                Button(action: viewModel.addAttribute) {
//                    Image(systemName: "plus")
//                }
//                Button(action: viewModel.removeAttributes) {
//                    Image(systemName: "minus")
//                }
//            }
//            .padding(.horizontal)
//            
//            AttributesView(items: $viewModel.attributes, selected: $viewModel.selectedAttributes)
//        }
//    }
//}
//
//struct DataModelView_Previews: PreviewProvider {
//    static var previews: some View {
//        DataModelView(viewModel: .init(type: .plain))
//    }
//}
