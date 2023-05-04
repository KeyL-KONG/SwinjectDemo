//
//  InitializationCallback.swift
//  SwinjectDemo
//
//  Created by LQ on 2023/4/4.
//

import Foundation
import Swinject

extension ViewController {
    
    func initializationCallback() {
        var called = false
        let container = Container()
        container.register(Animal.self, name: "cb") { _ in
            Cat(name: "Mew")
        }.initCompleted { _, _ in
            called = true
            print("init completion")
        }
        print(called)
        
        _ = container.resolve(Animal.self, name: "cb")
        print(called)
        _ = container.resolve(Animal.self, name: "cb")
    }
    
}
