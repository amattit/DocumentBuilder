////
////  HTTPMethodView.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 16.09.2023.
////
//
//import SwiftUI
//
//struct HTTPMethodView: View {
//    let items: [Method]
//    @Binding var selected: Method
//    
//    var body: some View {
//        HStack {
//            Text("HTTP method")
//            Menu {
//                ForEach(items) { item in
//                    Button(action: {
//                        selected = item
//                    }) {
//                        Text(item.rawValue)
//                    }
//                }
//            } label: {
//                Text(selected.rawValue)
//            }
//            .menuStyle(.button)
//            .frame(maxWidth: 300)
//        }
//    }
//}
