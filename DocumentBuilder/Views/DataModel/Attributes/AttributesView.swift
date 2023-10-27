////
////  AttributesView.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 16.09.2023.
////
//
//import SwiftUI
//
//struct AttributesView: View {
//    @Binding var items: [ModelAttribute]
//    @Binding var selected: Set<ModelAttribute.ID>
//    @State var popover: String?
//    
//    var body: some View {
//        Table($items, selection: $selected) {
//            TableColumn("Название") { attribute in
//                TextField("название", text: attribute.title)
//            }
//            .width(ideal: 150, max: 200)
//            
//            TableColumn("Тип данных") { attribute in
//                TextField("Тип", text: attribute.type)
//            }
//            .width(ideal: 150, max: 200)
//            
//            TableColumn("О/Н") { attribute in
//                Toggle("", isOn: attribute.isRequired)
//            }
//            .width(ideal: 30, max: 30)
//            
//            TableColumn("Комментарий") { attribute in
//                HStack {
//                    TextField("Комментарий", text: attribute.comment)
//                    Button(action: { showPopover(attribute.wrappedValue) }) {
//                        Image(systemName: "info.circle.fill")
//                    }
//                }
//            }
//        }
//        .popover(item: $popover) { info in
//            VStack(alignment: .leading) {
//                HStack {
//                    Text(info)
//                        .textSelection(.enabled)
//                    Spacer()
//                }
//            }
//            .padding(16)
//            .frame(width: 400, height: 300)
//        }
//        .frame(height: tableHeight())
//        .scrollDisabled(true)
//    }
//    
//    func tableHeight() -> CGFloat {
//        CGFloat(items.count) * 28 + 30
//    }
//    
//    func showPopover(_ item: ModelAttribute) {
//        popover = item.comment
//    }
//}
