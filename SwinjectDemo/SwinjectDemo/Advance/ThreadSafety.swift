//
//  ThreadSafety.swift
//  SwinjectDemo
//
//  Created by LQ on 2023/4/16.
//

import Foundation
import Swinject

protocol SomeType {}
class SomeImplementation: SomeType {}

extension ViewController {
    
    func threadSafety() {
        let container = Container()
        container.register(SomeType.self) { _ in
            SomeImplementation()
        }
        let threadSafeContainer: Resolver = container.synchronize()
        for _ in 0 ..< 4 {
            DispatchQueue.global().async {
                let resolvedInstance = threadSafeContainer.resolve(SomeType.self) as! SomeImplementation
                print(ObjectIdentifier(resolvedInstance))
            }
        }
        
        let parentContainer = Container()
        parentContainer.register(SomeType.self) { _ in
            SomeImplementation()
        }
        let parentResolver = parentContainer.synchronize()
        let childResolver = Container(parent: parentContainer).synchronize()
        
        for _ in 0 ..< 4 {
            DispatchQueue.global().async {
                let instanceFromParent = parentResolver.resolve(SomeType.self) as! SomeImplementation
                print(ObjectIdentifier(instanceFromParent))
            }
            DispatchQueue.global().async {
                let instanceFromChild = childResolver.resolve(SomeType.self) as! SomeImplementation
                print(ObjectIdentifier(instanceFromChild))
            }
        }
    }
    
}
