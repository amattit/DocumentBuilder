//
//  Logger.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 22.10.2023.
//

import Foundation
import os

final class Logger {
    private let logger: os.Logger
    
    init(module: String) {
        self.logger = os.Logger(subsystem: Bundle.main.bundleIdentifier ?? "N/A", category: module)
    }
    
    func info(message: String) {
        logger.info("\(message)")
        toConsole(message)
    }
    
    func debug(message: String) {
        logger.debug("\(message)")
        toConsole(message)
    }
    
    func error(message: String) {
        logger.error("\(message)")
        toConsole(message)
    }
    
    func notice(message: String) {
        logger.notice("\(message)")
        toConsole(message)
    }
    
    func trace(message: String) {
        logger.trace("\(message)")
        toConsole(message)
    }
    
    func toConsole(_ message: String) {
        print(message)
    }
}
