//
//  InjectablePatterns.swift
//  SwinjectDemo
//
//  Created by LQ on 2023/4/4.
//

import Foundation
import Swinject

class InjectablePerson: Person {
    
    var pet: Animal? {
        didSet {
            log = "Injected by property."
        }
    }
    
    var log = ""
    
    init() {}
    
    init(pet: Animal) {
        self.pet = pet
        log = "Injected by initializer."
    }
    
    func setPet(_ pet: Animal) {
        self.pet = pet
        log = "Injected by method."
    }
    
    func play() -> String {
        return log
    }
    
}

extension ViewController {
    
    func injectablePatterns() {
        let container = Container()
        container.register(Animal.self) { _ in
            return Cat(name: "cat")
        }
        
        container.register(Person.self, name: "initializer") { r in
            InjectablePerson(pet: r.resolve(Animal.self)!)
        }
        
        let initializerInjection = container.resolve(Person.self, name: "initializer")!
        print(initializerInjection.play())
        
        // property injection1
        container.register(Person.self, name: "property1") { r in
            let person = InjectablePerson()
            person.pet = r.resolve(Animal.self)
            return person
        }
        
        let propertyInjection1 = container.resolve(Person.self, name:"property1")!
        print(propertyInjection1.play())
        
        // Property injection 2 (in the initCompleted callback)
        container.register(Person.self, name: "property2") { _ in InjectablePerson() }
            .initCompleted { r, p in
                let injectablePerson = p as! InjectablePerson
                injectablePerson.pet = r.resolve(Animal.self)
            }

        let propertyInjection2 = container.resolve(Person.self, name: "property2")!
        print(propertyInjection2.play())
    }
    
}
