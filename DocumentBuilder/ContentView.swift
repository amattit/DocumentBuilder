//
//  ContentView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 03.09.2023.
//

import SwiftUI
import Back

struct ContentView: View {
//    @ObservedObject var viewModel: ModuleListViewModel
    
    var body: some View {
        Back.ContentView()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let persistent = Persistent(inMemory: true)
//        let module = Module(context: persistent.context)
//        let text = "Lorem Ipsum - это текст-\"рыба\", часто используемый в печати и вэб-дизайне. Lorem Ipsum является стандартной \"рыбой\" для текстов на латинице с начала XVI века. В то время некий безымянный печатник создал большую коллекцию размеров и форм шрифтов, используя Lorem Ipsum для распечатки образцов. Lorem Ipsum не только успешно пережил без заметных изменений пять веков, но и перешагнул в электронный дизайн. Его популяризации в новое время послужили публикация листов Letraset с образцами Lorem Ipsum в 60-х годах и, в более недавнее время, программы электронной вёрстки типа Aldus PageMaker, в шаблонах которых используется Lorem Ipsum. 1"
//        module.id = UUID()
//        module.title = "Module 0"
//        module.createdAt = Date()
//        module.subtitle = text
//        
//        
//        (1..<5).forEach { i in
//            let module = Module(context: persistent.context)
//            let text = "Lorem Ipsum - это текст-\"рыба\", часто используемый в печати и вэб-дизайне. Lorem Ipsum является стандартной \"рыбой\" для текстов на латинице с начала XVI века. В то время некий безымянный печатник создал большую коллекцию размеров и форм шрифтов, используя Lorem Ipsum для распечатки образцов. Lorem Ipsum не только успешно пережил без заметных изменений пять веков, но и перешагнул в электронный дизайн. Его популяризации в новое время послужили публикация листов Letraset с образцами Lorem Ipsum в 60-х годах и, в более недавнее время, программы электронной вёрстки типа Aldus PageMaker, в шаблонах которых используется Lorem Ipsum. 1"
//            module.id = UUID()
//            module.title = "Module \(i)"
//            module.createdAt = Date()
//            module.subtitle = text
//            
//            let feature = Feature(context: persistent.context)
//            feature.id = UUID()
//            feature.parentId = module.id!
//            feature.title = "Feature \(i)"
//            feature.featureDescription = text
//            feature.createdAt = Date()
//            
//            let service = Service(context: persistent.context)
//            service.id = UUID()
//            service.parentId = module.id!
//            service.title = "Service \(i)"
//            service.createdAt = Date()
//            
//            let dataModel = DataModel(context: persistent.context)
//            dataModel.title = "DataModel \(i)"
//            dataModel.createdAt = Date()
//            dataModel.id = UUID()
//            dataModel.parentId = module.id!
//        }
//        
//        try! persistent.context.save()
//        let view = withDependencies { dep in
//            dep.persistent = persistent
//        } operation: {
//            ContentView(viewModel: .init())
//        }
//
//        return view
//    }
//}
