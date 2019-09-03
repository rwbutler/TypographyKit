//
//  LoggingService.swift
//  TypographyKit
//
//  Created by Roger Smith on 30/08/2019.
//

import os

struct LoggingService {
    static func log(error: ParsingError, key: String) {
        let logMessage = "TypographyKit \(key) \(error.localizedDescription)"
        if #available(iOS 10, *) {
            os_log("%@", log: OSLog.default, type: .debug, logMessage)
        } else {
            #if DEBUG
            NSLog(String(describing: logMessage))
            #endif
        }
    }
}
