//
//  File.swift
//  
//
//  Created by Михаил Серегин on 24.10.2023.
//

import Foundation
import os

public final class Logger {
    private let logger: os.Logger
    
    public init(module: String) {
        self.logger = os.Logger(subsystem: Bundle.main.bundleIdentifier ?? "N/A", category: module)
    }
    
    public func info(message: String) {
        logger.info("\(message)")
        toConsole(message)
    }
    
    public func debug(message: String) {
        logger.debug("\(message)")
        toConsole(message)
    }
    
    public func error(message: String) {
        logger.error("\(message)")
        toConsole(message)
    }
    
    public func notice(message: String) {
        logger.notice("\(message)")
        toConsole(message)
    }
    
    public func trace(message: String) {
        logger.trace("\(message)")
        toConsole(message)
    }
    
    public func toConsole(_ message: String) {
        print(message)
    }
}
