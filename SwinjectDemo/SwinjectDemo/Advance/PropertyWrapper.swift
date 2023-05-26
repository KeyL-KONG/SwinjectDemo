//
//  PropertyWrapper.swift
//  SwinjectDemo
//
//  Created by ByteDance on 2023/5/26.
//

import Foundation
import Swinject


public let container = Container()

@propertyWrapper
struct AutoRegister<Service> {
    var wrappedValue: Service
    
    init() {
        guard let service = container.resolve(Service.self) else {
            fatalError("Failed to resolve service: \(Service.self)")
        }
        self.wrappedValue = service
    }
}

protocol GreetingService {
    func greet(name: String) -> String
}

class DefaultGreetingService: GreetingService {
    func greet(name: String) -> String {
        return "Hello, \(name)!"
    }
}

struct User {
    @AutoRegister
    var greetingService: GreetingService
    let name: String
    
    func sayHello() -> String {
        return greetingService.greet(name: name)
    }
}

extension ViewController {
    
    func autoResolver() {
        container.register(GreetingService.self) { _ in
            DefaultGreetingService()
        }
        let user = User(name: "John")
        print(user.sayHello())
    }
    
}

