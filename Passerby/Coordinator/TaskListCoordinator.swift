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
        
        viewModel.showNewTask
            .subscribe(onNext: { [weak self] in self?.showAddTask() })
            .disposed(by: bag)
        
        viewModel.showEditTask
            .subscribe(onNext: {[weak self] taskId in
                if taskId != "" { self?.showEditTask(taskid: taskId) }
            })
            .disposed(by: bag)
    }
    
    
    private func showEditTask(taskid: String) {
        lazy var editTaskVC: EditTaskVC = {
            let vc = EditTaskVC()
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
        lazy var dialogVC: PBDialogVC = {
            let vc = PBDialogVC()
            return vc
        }()
        
        let editTaskViewModel = NewTaskViewModel(user: self.user)
        editTaskVC.viewModel = editTaskViewModel
        
        editTaskVC.prioSegmentedVC = prioSegmentedVC
        editTaskVC.weightSegmentedVC = weightSegmentedVC
        editTaskVC.ownerPickerVC = ownerPickerVC
        editTaskVC.dialogVC = dialogVC
        //        editTaskVC.statePickerVC = statePickerVC
        
        prioSegmentedVC.viewModel = editTaskViewModel
        weightSegmentedVC.viewModel = editTaskViewModel
        ownerPickerVC.viewModel = editTaskViewModel
        dialogVC.viewModel = editTaskViewModel
        //        statePickerVC.viewModel = editTaskViewModel
        
        rootViewController.pushViewController(editTaskVC, animated: true)
        
        editTaskViewModel.backToTasksList
            .subscribe(onNext: { _ in
                editTaskVC.navigationController?.popViewController(animated: true)
            } )
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
    
    
    private func showAddTask() {
        lazy var newTaskVC: NewTaskVC = {
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

        lazy var dialogVC: PBDialogVC = {
            let vc = PBDialogVC()
            return vc
        }()
        
        let editTaskViewModel = NewTaskViewModel(user: self.user)
        newTaskVC.viewModel = editTaskViewModel
        
        newTaskVC.prioSegmentedVC = prioSegmentedVC
        newTaskVC.weightSegmentedVC = weightSegmentedVC
        newTaskVC.ownerPickerVC = ownerPickerVC
        newTaskVC.dialogVC = dialogVC
        
        prioSegmentedVC.viewModel = editTaskViewModel
        weightSegmentedVC.viewModel = editTaskViewModel
        ownerPickerVC.viewModel = editTaskViewModel
        dialogVC.viewModel = editTaskViewModel
        //        statePickerVC.viewModel = editTaskViewModel
        
        rootViewController.pushViewController(newTaskVC, animated: true)
        
        editTaskViewModel.backToTasksList
            .subscribe(onNext: { _ in
                newTaskVC.navigationController?.popViewController(animated: true)
            } )
            .disposed(by: bag)
    }

}

