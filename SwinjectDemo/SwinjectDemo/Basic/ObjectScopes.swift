//
//  ObjectScopes.swift
//  SwinjectDemo
//
//  Created by LQ on 2023/4/15.
//

import Foundation
import Swinject

protocol UserRepository {}
protocol UserService {}

class UserRepositoryImpl: UserRepository {
    
}

class UserServiceImpl: UserService {
    let userRepository: UserRepository
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
}

extension ViewController {
    
    func objectScopes() {
        let container = Container()
        container.register(Animal.self) { r in
            let name = UUID().uuidString
            return Cat(name: name)
        }.inObjectScope(.container)
        
        if let animalName = container.resolve(Animal.self)?.name, let animalName2 = container.resolve(Animal.self)?.name {
            print("container mode: \(animalName), \(animalName2)")
        }
        
        container.register(Animal.self, name: "transient") { r in
            let name = UUID().uuidString
            return Cat(name: name)
        }.inObjectScope(.transient)
        
        if let animalName3 = container.resolve(Animal.self, name: "transient")?.name, let animalName4 = container.resolve(Animal.self, name: "transient")?.name {
            print("transient mode: \(animalName3), \(animalName4)")
        }
        
        container.register(Animal.self, name: "graph") { r in
            let name = UUID().uuidString
            return Cat(name: name)
        }.inObjectScope(.graph)
        
        if let animalName5 = container.resolve(Animal.self, name: "graph")?.name, let animalName6 = container.resolve(Animal.self, name: "graph")?.name {
            print("graph mode: \(animalName5), \(animalName6)")
        }
        
        /// transient vs graph
        container.register(UserRepository.self) { _ in
            UserRepositoryImpl()
        }.inObjectScope(.transient)
        container.register(UserService.self) { r in
            UserServiceImpl(userRepository: r.resolve(UserRepository.self)!)
        }.inObjectScope(.transient)
        
        let userService1 = container.resolve(UserService.self) as! UserServiceImpl
        let userService2 = container.resolve(UserService.self) as! UserServiceImpl
        print("transient mode")
        print(ObjectIdentifier(userService1.userRepository as! UserRepositoryImpl))
        print(ObjectIdentifier(userService2.userRepository as! UserRepositoryImpl))
        
        container.register(UserRepository.self, name: "graph") { _ in
            UserRepositoryImpl()
        }.inObjectScope(.graph)
        container.register(UserService.self, name: "graph") { r in
            UserServiceImpl(userRepository: r.resolve(UserRepository.self)!)
        }.inObjectScope(.transient)
        let userService3 = container.resolve(UserService.self, name: "graph") as! UserServiceImpl
        let userService4 = container.resolve(UserService.self, name: "graph") as! UserServiceImpl
        print("graph mode")
        print(ObjectIdentifier(userService3.userRepository as! UserRepositoryImpl))
        print(ObjectIdentifier(userService4.userRepository as! UserRepositoryImpl))
        
    }
    
    func objectScopes2() {
        transientMode()
        graphMode()
        containerMode()
        weakMode()
    }
    
}

// MARK - transient mode
protocol MyServiceProtocol {
    func doSomething()
}

class MyService: MyServiceProtocol {
    func doSomething() {
        print("MyService doSomething called.")
    }
}

class MyViewController {
    var myService: MyServiceProtocol
    
    init(myService: MyServiceProtocol) {
        self.myService = myService
    }
}

extension ViewController {
    func transientMode() {
        let container = Container()
        container.register(MyServiceProtocol.self) { _ in
            MyService()
        }
        container.register(MyViewController.self) { r in
            MyViewController(myService: r.resolve(MyServiceProtocol.self)!)
        }.inObjectScope(.transient)
        
        let viewController1 = container.resolve(MyViewController.self)!
        let viewController2 = container.resolve(MyViewController.self)!

        print("transient viewController1 === viewController2: \(viewController1 === viewController2)") // Output: false
    }
}


// MARK - graph mode
class MySingletonService: MySingletonServiceProtocol {
    func doSomething() {
        print("MySingletonService doSomething called.")
    }
}

protocol MySingletonServiceProtocol: MyServiceProtocol {
}

extension ViewController {
    func graphMode() {
        let container = Container()

        container.register(MySingletonServiceProtocol.self) { _ in MySingletonService() }
        container.register(MyViewController.self) { r in
            MyViewController(myService: r.resolve(MySingletonServiceProtocol.self)!)
        }.inObjectScope(.graph)

        let viewController1 = container.resolve(MyViewController.self)!
        let viewController2 = container.resolve(MyViewController.self)!

        print("graph viewController1 === viewController2: \(viewController1 === viewController2)") // Output: false
    }
}

// MARK - container mode
protocol MyContainerServiceProtocol: MyServiceProtocol {
}

class MyContainerService: MyContainerServiceProtocol {
    func doSomething() {
        print("MyContainerService doSomething called.")
    }
}


extension ViewController {
    func containerMode() {
        let container = Container()
        container.register(MyContainerServiceProtocol.self) { _ in
            MyContainerService()
        }
        container.register(MyViewController.self) { r in
            MyViewController(myService: r.resolve(MyContainerServiceProtocol.self)!)
        }.inObjectScope(.container)
        
        let viewController1 = container.resolve(MyViewController.self)!
        //container.resetObjectScope(.container)
        
        let viewController2 = container.resolve(MyViewController.self)!
        print("container viewController1 === viewController2: \(viewController1 === viewController2)") // Output: false
    }
}


protocol MyWeakServiceProtocol: MyServiceProtocol {
}

class MyWeakService: MyWeakServiceProtocol {
    func doSomething() {
        print("MyWeakService doSomething called.")
    }
}

extension ViewController {
    func weakMode() {
        let container = Container()
        container.register(MyWeakServiceProtocol.self) { _ in
            MyWeakService()
        }
        container.register(MyViewController.self) { r in
            MyViewController(myService: r.resolve(MyWeakServiceProtocol.self)!)
        }.inObjectScope(.weak)
        
        var viewController1: MyViewController? = container.resolve(MyViewController.self)!
        var viewController2: MyViewController? = container.resolve(MyViewController.self)!
        print("weak viewController1 === viewController2: \(viewController1 === viewController2)") // Output: false
        
        viewController1 = nil
        viewController2 = nil
        let service = container.resolve(MyWeakServiceProtocol.self)
        print("service == nil: \(service == nil)")
    }
}
