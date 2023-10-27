//
//  SwiftUIView.swift
//  
//
//  Created by Михаил Серегин on 26.10.2023.
//

import SwiftUI
import Core

public struct ContentView: View {
    public init() {}
    public var body: some View {
        NavigationSplitView {
            ModuleListView(viewModel: .init())
                .navigationDestination(for: Module.self) { module in
                    ModuleView(viewModel: .init(module: module))
                }
        } content: {
            Text("List")
                .navigationDestination(for: Service.self) { service in
                    ServiceView(viewModel: .init(service: service))
                }
        } detail: {
            Text("Details")
        }

    }
}

#Preview {
    ContentView()
}
