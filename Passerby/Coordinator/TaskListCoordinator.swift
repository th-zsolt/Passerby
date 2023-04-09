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
        
        viewModel.showAddTask
            .subscribe(onNext: { [weak self] in self?.showAddTask() })
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
    
    
    private func showAddTask() {
        lazy var editTaskVC: NewTaskVC = {
            let vc = NewTaskVC()
            return vc
        }()
        
        lazy var prioSegmentedVC: PrioSegmentedVC = {
            let vc = PrioSegmentedVC()
            return vc
        }()
        lazy var weightSegmentedVC: WeightSegmentedVC = {
            let vc = WeightSegmentedVC()
            return vc
        }()
        lazy var ownerPickerVC: OwnerPickerVC = {
            let vc = OwnerPickerVC()
            return vc
        }()
//        lazy var statePickerVC: StatePickerVC = {
//            let vc = StatePickerVC()
//            return vc
//        }()
                
        let editTaskViewModel = NewTaskViewModel(user: self.user)
        editTaskVC.viewModel = editTaskViewModel
        
        editTaskVC.prioSegmentedVC = prioSegmentedVC
        editTaskVC.weightSegmentedVC = weightSegmentedVC
        editTaskVC.ownerPickerVC = ownerPickerVC
//        editTaskVC.statePickerVC = statePickerVC
        
        prioSegmentedVC.viewModel = editTaskViewModel
        weightSegmentedVC.viewModel = editTaskViewModel
        ownerPickerVC.viewModel = editTaskViewModel
//        statePickerVC.viewModel = editTaskViewModel
        
        rootViewController.pushViewController(editTaskVC, animated: true)
    }
}

