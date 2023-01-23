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
    
    
    func loadTasksList() {
        let child = TaskListCoordinator(rootViewController: rootViewController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}
    
    
    //loginVC.buttonClicked
    //    .subscribe(onNext: { _ in self.showTasksList(in: self.rootViewController)})
    //    .disposed(by: bag)
    //}
    
    
    //    private func showTasksList(in navigationController: UINavigationController) {
    //
    //        let viewModel = TasksListViewModel()
    //        let tasksListVC  = TasksListVC()
    //        navigationController.pushViewController(tasksListVC, animated: true)
    //    }

