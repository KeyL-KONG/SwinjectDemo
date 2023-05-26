//
//  ViewController.swift
//  SwinjectDemo
//
//  Created by LQ on 2023/4/4.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        basicUse()
        namedRegistration()
        initializationCallback()
        injectablePatterns()
        objectScopes2()
        containerHierarchy()
        threadSafety()
        autoResolver()
    }


}

