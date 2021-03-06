//
//  Logomotive.swift
//  Pods
//
//  Created by Andreas on 27.11.16.
//
//

import Foundation

public typealias Log = Logomotive

public struct Logomotive {
    
    public static var logger: [Logger] = [ConsoleLogger(logLevel: .error)]
    
    public static func debug<T>(_ object: T, date: Date = Date(), filePath: String = #file, function: String = #function, line: Int = #line) {
        logMessage(object,
                   level: .debug,
                   date: date,
                   filePath: filePath,
                   function: function,
                   line: line)
    }
    
    public static func info<T>(_ object: T, date: Date = Date(), filePath: String = #file, function: String = #function, line: Int = #line) {
        logMessage(object,
                   level: .info,
                   date: date,
                   filePath: filePath,
                   function: function,
                   line: line)
    }
    
    public static func warning<T>(_ object: T, date: Date = Date(), filePath: String = #file, function: String = #function, line: Int = #line) {
        logMessage(object,
                   level: .warning,
                   date: date,
                   filePath: filePath,
                   function: function,
                   line: line)
    }
    
    public static func error<T>(_ object: T, date: Date = Date(), filePath: String = #file, function: String = #function, line: Int = #line) {
        logMessage(object,
                   level: .error,
                   date: date,
                   filePath: filePath,
                   function: function,
                   line: line)
    }
    
    private static func logMessage<T>(_ object: T, level: LogLevel, date: Date, filePath: String, function: String, line: Int) {       
        logger.forEach { (logger) in
            if logger.shouldLog(for: level) {
                let formatedMessage = format(object, logLevel: level, date: date, filePath: filePath, function: function, line: line, logger: logger, format: logger.format.description)
                logger.log(message: formatedMessage, with: level)
            }
        }
    }
    
    private static func format<T>(_ object: T, logLevel: LogLevel, date: Date, filePath: String, function: String, line: Int, logger: Logger, format: String) -> String {
        var formatedMessage = format
        formatedMessage = formatedMessage.replacingOccurrences(of: "#DATE#", with: "\(date)")
        formatedMessage = formatedMessage.replacingOccurrences(of: "#EXEC#", with: "\(Bundle.main.executableName)")
        formatedMessage = formatedMessage.replacingOccurrences(of: "#FILE#", with: "\(filePath.filename)")
        formatedMessage = formatedMessage.replacingOccurrences(of: "#FUNC#", with: "\(function)")
        formatedMessage = formatedMessage.replacingOccurrences(of: "#LINE#", with: "\(line)")
        formatedMessage = formatedMessage.replacingOccurrences(of: "#LEVEL#", with: "\(logLevel.description)")
        formatedMessage = formatedMessage.replacingOccurrences(of: "#EMOJI#", with: "\(logger.emoji(for: logLevel))")
        formatedMessage += "\(object)"
        
        return formatedMessage
    }
}

// MARK: - Extensions -

fileprivate extension String {
    var filename: String {
        let fileURL = NSURL(fileURLWithPath: self)
        return fileURL.deletingPathExtension?.lastPathComponent ?? ""
    }
}

internal extension Bundle {
    var executableName: String {
        let executableName = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String ?? ""
        return executableName
    }
}
