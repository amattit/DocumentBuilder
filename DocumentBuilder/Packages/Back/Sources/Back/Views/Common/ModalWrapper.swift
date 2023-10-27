//
//  File.swift
//  
//
//  Created by Михаил Серегин on 27.10.2023.
//

import SwiftUI

struct ModalWrapper<Content:View, Actions: View>: View {
    let content: () -> Content
    let actions: () -> Actions
    
    var body: some View {
        ScrollView {
            content()
            
            HStack {
                actions()
            }
        }
        .frame(minWidth: 600, minHeight: 500)
        
    }
}
