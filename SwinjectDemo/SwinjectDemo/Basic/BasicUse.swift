//
//  BasicUse.swift
//  SwinjectDemo
//
//  Created by LQ on 2023/4/4.
//

import Foundation
import Swinject

protocol Animal {
    var name: String? { get set }
    func sound() -> String
}

class Cat: Animal {
    var name: String?
    
    init(name: String) {
        self.name = name
    }
    
    func sound() -> String {
        return "Meow"
    }
}

protocol Person {
    func play() -> String
}

class PetOwner: Person {
    
    let pet: Animal
    
    init(pet: Animal) {
        self.pet = pet
    }
    
    func play() -> String {
        let name = pet.name ?? "someone"
        return "I'm playing with \(name). \(pet.sound())"
    }
}

extension ViewController {
    
    func basicUse() {
        let container = Container()
        container.register(Animal.self) { _ in
            Cat(name: "Mimi")
        }
        container.register(Person.self) { r in
            PetOwner(pet: r.resolve(Animal.self)!)
        }
        
        let person = container.resolve(Person.self)!
        print(person.play())
    }
    
}
