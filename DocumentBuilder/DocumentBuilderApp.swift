//
//  DocumentBuilderApp.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 03.09.2023.
//

import SwiftUI

@main
struct DocumentBuilderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init())
        }
    }
}
