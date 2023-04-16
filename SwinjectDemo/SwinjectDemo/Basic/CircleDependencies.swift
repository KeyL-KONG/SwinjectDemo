//
//  CircleDependencies.swift
//  SwinjectDemo
//
//  Created by LQ on 2023/4/15.
//

import Foundation
import Swinject

protocol ParentProtocol: AnyObject {}
protocol ChildProtocol: AnyObject {}

class Parent: ParentProtocol {
    let child: ChildProtocol?
    init(child: ChildProtocol?) {
        self.child = child
    }
}

class Child: ChildProtocol {
    weak var parent: ParentProtocol?
}

extension ViewController {
    
    func circleDependencies() {
        let container = Container()
        container.register(ParentProtocol.self) { r in
            Parent(child: r.resolve(ChildProtocol.self)!)
        }
        container.register(ChildProtocol.self) { _ in
            Child()
        }.initCompleted { r, c in
            let child = c as! Child
            child.parent = r.resolve(ParentProtocol.self)
        }
    }
    
}
