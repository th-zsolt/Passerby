//
//  MainCoordinator.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 18..
//

import UIKit

class MainCoordinator: Coordinator {
    
    var rootViewController = UINavigationController()
        
    lazy var taskListVC: TasksListVC = {
        let vc = TasksListVC()
        return vc
    }()
    
    func start() {
        rootViewController.setViewControllers([taskListVC], animated: false)
    }
}
