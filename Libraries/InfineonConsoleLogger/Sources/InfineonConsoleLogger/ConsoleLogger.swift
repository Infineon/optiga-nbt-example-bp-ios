// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonLogger
import os.log

/// This class provides logging functionality with instance methods.
public class ConsoleLogger: ILogger {
    /// Static ConsoleLogger instance for single tone pattern
    private static var logger: ConsoleLogger?

    /// Logger instance to use.
    private let log: Logger = .init()
    /// Current log level.
    private var loggerLevel: Int = LoggerLevel.all.rawValue

    /// Private initializer for the ConsoleLogger class.
    private init() {
        // This method is intentionally left empty as it is a private initializer.
    }

    /// This method is used to get an instance of the console logger.
    /// - Returns: An instance of the ILogger protocol representing the console logger.
    public static func getConsoleLogger() -> ILogger {
        if ConsoleLogger.logger == nil {
            logger = ConsoleLogger()
        }
        return logger!
    }

    /// Logs an error message along with a header to categorize the error.
    /// The header parameter is a string that represents the category or
    /// the source of the error, while the message parameter is a string
    /// that contains the error message.
    ///
    /// - Parameters:
    ///   - header: A string that represents the category or the source of the error.
    ///   - message: A string that contains the error message.
    ///
    public func error(header: String, message: String) {
        let consoleString =
            LoggerUtils.getConsoleString(stringArray: [
                header,
                message
            ])
        if loggerLevel >= LoggerLevel.error.rawValue {
            log.error("\(LoggerUtils.getFormattedConsoleString(consoleString: consoleString))")
        }
    }

    /// Logs an error message along with a header to categorize the error.
    /// The header parameter is a string that represents the category or
    /// the source of the error, while the data parameter is a binary data
    /// that contains additional information about the error.
    ///
    /// - Parameters:
    ///   - header: A string that represents the category or the source of the error.
    ///   - data: A binary data that contains additional information about the error.
    ///
    public func error(header: String, data: Data) {
        let consoleString =
            LoggerUtils.getConsoleString(stringArray: [
                header,
                LoggerUtils.getFormattedString(data: data)
            ])
        if loggerLevel >= LoggerLevel.error.rawValue {
            log.error("\(LoggerUtils.getFormattedConsoleString(consoleString: consoleString))")
        }
    }

    /// Logs a warning message along with a header to categorize the warning.
    /// The header parameter is a string that represents the category or
    /// the source of the warning, while the message parameter is a string
    /// that contains the warning message.
    ///
    /// - Parameters:
    ///   - header: A string that represents the category or the source of the warning.
    ///   - message: A string that contains the warning message.
    ///
    public func warning(header: String, message: String) {
        let consoleString =
            LoggerUtils.getConsoleString(stringArray: [
                header,
                message
            ])
        if loggerLevel >= LoggerLevel.warning.rawValue {
            log.warning("\(LoggerUtils.getFormattedConsoleString(consoleString: consoleString))")
        }
    }

    /// Logs a warning message along with a header to categorize the warning.
    /// The header parameter is a string that represents the category or
    /// the source of the warning, while the data parameter is a binary
    /// data that contains additional information about the warning.
    ///
    /// - Parameters:
    ///   - header: A string that represents the category or the source of the warning.
    ///   - data: A binary data that contains additional information about the warning.
    ///
    public func warning(header: String, data: Data) {
        let consoleString =
            LoggerUtils.getConsoleString(stringArray: [
                header,
                LoggerUtils.getFormattedString(data: data)
            ])
        if loggerLevel >= LoggerLevel.warning.rawValue {
            log.warning("\(LoggerUtils.getFormattedConsoleString(consoleString: consoleString))")
        }
    }

    /// Logs an informational message along with a header to categorize the message.
    /// The header parameter is a string that represents the category or
    /// the source of the message, while the message parameter is a
    /// string that contains the informational message.
    ///
    /// - Parameters:
    ///   - header: A string that represents the category or the source of the message.
    ///   - message: A string that contains the informational message.
    ///
    public func info(header: String, message: String) {
        let consoleString =
            LoggerUtils.getConsoleString(stringArray: [
                header,
                message
            ])
        if loggerLevel >= LoggerLevel.info.rawValue {
            log.info("\(LoggerUtils.getFormattedConsoleString(consoleString: consoleString))")
        }
    }

    /// Logs an informational message along with a header to categorize the message.
    /// The header parameter is a string that represents the category or
    /// the source of the message, while the data parameter is a binary
    /// data that contains additional information about the message.
    ///
    /// - Parameters:
    ///   - header:  A string that represents the category or the source of the message.
    ///   - data: A binary data that contains additional information about the message.
    ///
    public func info(header: String, data: Data) {
        let consoleString =
            LoggerUtils.getConsoleString(stringArray: [
                header,
                LoggerUtils.getFormattedString(data: data)
            ])
        if loggerLevel >= LoggerLevel.info.rawValue {
            log.info("\(LoggerUtils.getFormattedConsoleString(consoleString: consoleString))")
        }
    }

    /// Logs a debug message along with a header to categorize the message.
    /// The header parameter is a string that represents the category or
    /// the source of the message, while the message parameter is a
    /// string that contains the debug message.
    ///
    /// - Parameters:
    ///   - header: A string that represents the category or the source of the message.
    ///   - message: A string that contains the debug message.
    ///
    public func debug(header: String, message: String) {
        let consoleString =
            LoggerUtils.getConsoleString(stringArray: [
                header,
                message
            ])
        if loggerLevel >= LoggerLevel.debug.rawValue {
            log.warning("\(LoggerUtils.getFormattedConsoleString(consoleString: consoleString))")
        }
    }

    /// Logs a debug message along with a header to categorize the message.
    /// The header parameter is a string that represents the category or
    /// the source of the message, while the data parameter is a binary
    /// data that contains additional information about the message.
    ///
    /// - Parameters:
    ///   - header: A string that represents the category or the source of the message.
    ///   - data: A binary data that contains additional information about the message.
    ///
    public func debug(header: String, data: Data) {
        let consoleString =
            LoggerUtils.getConsoleString(stringArray: [
                header,
                LoggerUtils.getFormattedString(data: data)
            ])
        if loggerLevel >= LoggerLevel.debug.rawValue {
            log.warning("\(LoggerUtils.getFormattedConsoleString(consoleString: consoleString))")
        }
    }

    /// Sets the logger level. The logger level determines which messages are
    /// logged and which ones are not. By setting the logger level, it controls the
    /// granularity of the log messages.
    ///
    /// - Parameter loggerLevel: A value that represents the logger level.
    ///
    public func setLogLevel(loggerLevel: LoggerLevel) {
        self.loggerLevel = loggerLevel.rawValue
    }
}
