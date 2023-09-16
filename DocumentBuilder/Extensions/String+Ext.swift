//
//  String+Ext.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 04.09.2023.
//

import Foundation

extension String? {
    var nilIfEmpty: String? {
        guard let self else { return nil }
        if self.isEmpty { return nil }
        else { return self }
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
}
