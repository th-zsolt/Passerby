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
    
    lazy var loginVC: LoginVC = {
        let vc = LoginVC()
        return vc
    }()
    
    func start() {
           
//        let loginCoordinator = LoginCoordinator()
        let viewModel = LoginViewModel()
        
        rootViewController.setViewControllers([loginVC], animated: false)
        
        
        loginVC.buttonClicked
            .subscribe(onNext: { _ in self.showTasksList(in: self.rootViewController)})
            .disposed(by: bag)
    }
    
    
    private func showTasksList(in navigationController: UINavigationController) {
        
        let viewModel = TasksListViewModel()
        let tasksListVC  = TasksListVC()
        navigationController.pushViewController(tasksListVC, animated: true)
    }
}
