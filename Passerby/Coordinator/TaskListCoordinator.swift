//
//  TaskListCoordinator.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 28..
//

import UIKit
import RxSwift
import RxCocoa

class TaskListCoordinator: Coordinator {
    weak var parentCoordinator: MainCoordinator?
    var bag: DisposeBag = DisposeBag()
    var rootViewController = UINavigationController()

    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    func start() {
        lazy var tasksListVC: TasksListVC = {
            let vc = TasksListVC()
            return vc
        }()
        
        let viewModel = TasksListViewModel()
        tasksListVC.viewModel = viewModel
        rootViewController.pushViewController(tasksListVC, animated: true)
    }
}
