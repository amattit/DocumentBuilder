////
////  ModelRowView.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 10.09.2023.
////
//
//import SwiftUI
//
//struct ModelRowView: View {
//    let model: DataModel
//    var body: some View {
//        HStack {
//            Text(title)
//            Spacer()
//        }
//    }
//    
//    var title: String {
//        model.title ?? "N/A"
//    }
//}
//
////struct ModelRowView_Previews: PreviewProvider {
////    static var model: DataModel {
////        let persistent = Persistent(inMemory: true)
////        let model = DataModel(context: persistent.context)
////        model.title = "Создание заметки"
////        model.modelType = "network"
////        persistent.save()
////        return model
////    }
////    static var previews: some View {
////        ModelRowView(model: model)
////    }
////}
