//
//  ObservableObject+Error.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 16.09.2023.
//

import Foundation

extension ObservableObject {
    func tryAction(_ action: () throws -> Void) {
        do {
            try action()
        } catch {
            print(error.localizedDescription)
        }
    }
}
