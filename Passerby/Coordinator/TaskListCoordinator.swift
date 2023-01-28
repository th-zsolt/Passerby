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
    var user: User


    init(rootViewController: UINavigationController, user: User) {
        self.rootViewController = rootViewController
        self.user = user
    }

    func start() {
        lazy var tasksListVC: TasksListVC = {
            let vc = TasksListVC()
            return vc
        }()
        
        let _currentUser = BehaviorRelay<User>(value: user)
        var currentUser: Driver<User> {
            return _currentUser.asDriver()
        }
        
        let viewModel = TasksListViewModel(user: currentUser)
        tasksListVC.viewModel = viewModel
        rootViewController.pushViewController(tasksListVC, animated: true)
        
        viewModel.showAccount
            .subscribe(onNext: { [weak self] in self?.showAccount(user: currentUser) })
            .disposed(by: bag)
    }
    
    
    private func showAccount(user: Driver<User>) {
        lazy var accountVC: AccountVC = {
            let vc = AccountVC()
            return vc
        }()
        
        let accountViewModel = AccountViewModel(user: self.user)
        accountVC.viewModel = accountViewModel
        rootViewController.pushViewController(accountVC, animated: true)
    }
}
