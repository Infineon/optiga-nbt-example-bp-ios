<!--
SPDX-FileCopyrightText: 2024 Infineon Technologies AG
SPDX-License-Identifier: MIT
-->

# Infineon Console Logger Swift Library

This library developed on top of InfineonLogger Library. This library extends the ILogger interface and implements the functionality to log different levels of messages like error, warning, info and debug. By default, the log level is set to `all`, so all log messages will be logged. To change the log level, set the loggerLevel property of the Logger instance (The logger levels, in order of increasing verbosity, are: `none`, `error`, `warning`, `info`, `debug`, and `all`).

## Example

``` swift
/// Import InfineonLogger to access InfineonLogger level functions, enums etc.
import InfineonLogger

/// Import InfineonConsoleLogger to access InfineonLogger level functions.
import InfineonConsoleLogger


// Initialize the instance of the ConsoleLogger class
var logger =  ConsoleLogger()

// set the loggerLevel property of the Logger instance to warning.
logger.setLogLevel(loggerLevel: LoggerLevel.warning)

// logs the warning.
logger.warning(header: "expected header", data: Data())

// set the loggerLevel property of the Logger instance to all.
logger.setLogLevel(loggerLevel: LoggerLevel.all)

// logs the error.
logger.error(header: expectedHeader, message: "expected error message")


// logs the info.
logger.info(header: expectedHeader, message: "expected info message")
