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
        print(ObjectIdentifier(userService3.userRepository as! UserRepositoryImpl))
        print(ObjectIdentifier(userService4.userRepository as! UserRepositoryImpl))
        
    }
    
}
