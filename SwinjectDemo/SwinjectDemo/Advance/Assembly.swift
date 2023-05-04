//
//  Assembly.swift
//  SwinjectDemo
//
//  Created by LQ on 2023/4/16.
//

import Foundation
import Swinject

protocol FooServiceProtocol {}
protocol BarServiceProtocol {}
protocol FooManagerProtocol {}
protocol BarManagerProtocol {}

class FooService: FooServiceProtocol {
    
}

class BarService: BarServiceProtocol {
    
}

class FooManager: FooManagerProtocol {
    let fooService: FooServiceProtocol
    init(fooService: FooServiceProtocol) {
        self.fooService = fooService
    }
}

class BarManager: BarManagerProtocol {
    let barService: BarServiceProtocol
    init(barService: BarServiceProtocol) {
        self.barService = barService
    }
}

class ServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(FooServiceProtocol.self) { r in
            FooService()
        }
        container.register(BarServiceProtocol.self) { r in
            BarService()
        }
    }
    
}

class ManagerAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(FooManagerProtocol.self) { r in
            FooManager(fooService: r.resolve(FooServiceProtocol.self)!)
        }
        container.register(BarManagerProtocol.self) { r in
            BarManager(barService: r.resolve(BarServiceProtocol.self)!)
        }
    }
    
}

protocol LogHandler {
    func log(message: String)
}

class Logger {
    static let shareInstance = Logger()
    private init() {}
    
    var logHandlers = [LogHandler]()
    
    func addHandler(logHandler: LogHandler) {
        logHandlers.append(logHandler)
    }
    
    func log(message: String) {
        for logHandler in logHandlers {
            logHandler.log(message: message)
        }
    }
}

class ConsoleLogHandler: LogHandler {
    func log(message: String) {
        print("console: \(message)")
    }
}

class FileLogHandler: LogHandler {
    func log(message: String) {
        print("filelog: \(message)")
    }
}

class LoggerAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(LogHandler.self, name: "console") { r in
            ConsoleLogHandler()
        }
        container.register(FileLogHandler.self, name: "file") { r in
            FileLogHandler()
        }
    }
    
    func loaded(resolver: Resolver) {
        Logger.shareInstance.addHandler(logHandler: resolver.resolve(LogHandler.self, name: "console")!)
        Logger.shareInstance.addHandler(logHandler: resolver.resolve(LogHandler.self, name: "file")!)
    }
}

extension ViewController {
    
    func assembly() {
        let assembler = Assembler([ServiceAssembly(), ManagerAssembly()])
        _ = assembler.resolver.resolve(FooManagerProtocol.self)!
        assembler.apply(assembly: LoggerAssembly())
    }
    
}
