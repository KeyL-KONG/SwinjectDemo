//
//  NamedRegistration.swift
//  SwinjectDemo
//
//  Created by LQ on 2023/4/4.
//

import Foundation
import Swinject

class Dog: Animal {
    var name: String?
    
    init(name: String) {
        self.name = name
    }
    
    func sound() -> String {
        return "Bow wow"
    }
}

extension ViewController {
    
    func namedRegistration() {
        let container = Container()
        container.register(Animal.self, name: "dog") { _ in
            Dog(name: "Hachi")
        }
        container.register(Person.self, name: "doggy") { r in
            PetOwner(pet: r.resolve(Animal.self, name: "dog")!)
        }
        
        let doggyPerson = container.resolve(Person.self, name: "doggy")!
        print(doggyPerson.play())
    }
    
}
