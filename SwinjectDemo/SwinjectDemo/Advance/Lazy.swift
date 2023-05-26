//
//  Lazy.swift
//  SwinjectDemo
//
//  Created by LQ on 2023/5/21.
//

import Foundation
import Swinject

extension ViewController {
    
    func lazyContainer() {
        let container = Container()
        container.register(MyService.self) { r in
            MyService()
        }.inObjectScope(.container).initCompleted { r, serivce in
            print("init service completed")
        }
        
        let lazyService = container.resolve(Lazy<MyService>.self)
        print("Before accessing value")
        let service = lazyService?.instance
        print("After accessing value")
    }
    
}

