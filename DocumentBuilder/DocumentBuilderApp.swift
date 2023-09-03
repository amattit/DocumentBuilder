//
//  DocumentBuilderApp.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 03.09.2023.
//

import SwiftUI

@main
struct DocumentBuilderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
