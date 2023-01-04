//
//  ApplicationCoordinator.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 18..
//

import UIKit
import RxSwift
import RxCocoa

class ApplicationCoordinator: Coordinator {
                  
    let window: UIWindow
    
    var childCoordinators = [Coordinator]()
    
    
    init(window: UIWindow) {
        
        self.window = window
    }
    
    
    func start() {
        window.rootViewController = LoginVC()
        
//        let mainCoordinator = MainCoordinator()
//        mainCoordinator.start()
//        self.childCoordinators = [mainCoordinator]
//        window.rootViewController = mainCoordinator.rootViewController
                
    }
    
    func clickButton() {
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start()
        self.childCoordinators = [mainCoordinator]
        window.rootViewController = mainCoordinator.rootViewController
    }
     
}
