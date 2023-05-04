//
//  ContainerHierarchy.swift
//  SwinjectDemo
//
//  Created by LQ on 2023/4/16.
//

import Foundation
import Swinject

extension ViewController {
    
    func containerHierarchy() {
        let parentContainer = Container()
        parentContainer.register(Animal.self) { _ in
            Cat(name: "cat")
        }
        let childContainer = Container(parent: parentContainer)
        let cat = childContainer.resolve(Animal.self)
        print(cat != nil) // output: true
        
        let parentContainer2 = Container()
        let childContainer2 = Container(parent: parentContainer2)
        childContainer2.register(Animal.self) { _ in
            Cat(name: "cat")
        }
        let cat2 = parentContainer2.resolve(Animal.self)
        print(cat2 != nil) // output: false
    }
    
}
