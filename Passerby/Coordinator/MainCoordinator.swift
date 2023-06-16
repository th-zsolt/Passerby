//
//  MainCoordinator.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 18..
//

import UIKit
import RxSwift
import RxCocoa

class MainCoordinator: Coordinator {
    
    var bag: DisposeBag = DisposeBag()
    
    var rootViewController = UINavigationController()
    
    var childCoordinators = [Coordinator]()
    
    
    func start() {
        let child = LoginCoordinator(rootViewController: rootViewController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    
    func loadTasksList(user: User) {
        let child = TaskListCoordinator(rootViewController: rootViewController, user: user)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}
    

