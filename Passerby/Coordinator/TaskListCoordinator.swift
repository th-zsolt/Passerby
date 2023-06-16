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
    
    let filterTaskViewModel : FilterTaskViewModel
    
    
    init(rootViewController: UINavigationController, user: User) {
        self.rootViewController = rootViewController
        self.user = user
        filterTaskViewModel = FilterTaskViewModel(user: self.user)
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
        
        filterTaskViewModel.doFilter
            .filter{ $0 != nil }
            .bind(to: viewModel.doFilterTaskList)
            .disposed(by: bag)
        
//        filterTaskViewModel.doFilter
//            .filter{ $0 != nil }
//            .subscribe(onNext: { filter in
//                self.filterItem = filter ?? self.filterItem
//            })
//            .disposed(by: bag)
        
        viewModel.showAccount
            .subscribe(onNext: { [weak self] in self?.showAccount(user: currentUser) })
            .disposed(by: bag)
        
        viewModel.showFilter
            .subscribe(onNext: { [weak self] in self?.showFilter(user: currentUser) })
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
            let vc = PrioSegmentedVC(withEmpty: false)
            return vc
        }()
        lazy var weightSegmentedVC: WeightSegmentedVC = {
            let vc = WeightSegmentedVC(withEmpty: false)
            return vc
        }()
        lazy var ownerPickerVC: TeamMemberPickerVC = {
            let vc = TeamMemberPickerVC()
            return vc
        }()
        
        lazy var statePickerVC: StatePickerVC = {
            let vc = StatePickerVC()
            return vc
        }()
        
        lazy var dialogVC: PBDialogVC = {
            let vc = PBDialogVC()
            return vc
        }()
        
        let editTaskViewModel = EditTaskViewModel(user: self.user, taskId: taskid)
        editTaskVC.viewModel = editTaskViewModel
        
        editTaskVC.prioSegmentedVC = prioSegmentedVC
        editTaskVC.weightSegmentedVC = weightSegmentedVC
        editTaskVC.ownerPickerVC = ownerPickerVC
        editTaskVC.dialogVC = dialogVC
        editTaskVC.statePickerVC = statePickerVC
        
        prioSegmentedVC.viewModel = editTaskViewModel
        weightSegmentedVC.viewModel = editTaskViewModel
        ownerPickerVC.viewModel = editTaskViewModel
        dialogVC.viewModel = editTaskViewModel
        statePickerVC.viewModel = editTaskViewModel
        
        rootViewController.pushViewController(editTaskVC, animated: true)
        
        editTaskViewModel.backToTasksList
            .subscribe(onNext: { _ in
                editTaskVC.navigationController?.popViewController(animated: true)
            } )
            .disposed(by: bag)
    }
    
    private func showFilter(user: Driver<User>) {
        lazy var filterTaskVC: FilterTaskVC = {
            let vc = FilterTaskVC()
            return vc
        }()
        
        lazy var prioSegmentedVC: PrioSegmentedVC = {
            let vc = PrioSegmentedVC(withEmpty: true)
            return vc
        }()
        lazy var weightSegmentedVC: WeightSegmentedVC = {
            let vc = WeightSegmentedVC(withEmpty: true)
            return vc
        }()
        lazy var reporterPickerVC: TeamMemberPickerVC = {
            let vc = TeamMemberPickerVC()
            return vc
        }()
        
        lazy var statePickerVC: StatePickerVC = {
            let vc = StatePickerVC()
            return vc
        }()
        
        filterTaskVC.viewModel = self.filterTaskViewModel
        rootViewController.pushViewController(filterTaskVC, animated: true)
        self.filterTaskViewModel.screenVisible.accept(true)
        
        filterTaskVC.prioSegmentedVC = prioSegmentedVC
        filterTaskVC.weightSegmentedVC = weightSegmentedVC
        filterTaskVC.reporterPickerVC = reporterPickerVC
        filterTaskVC.statePickerVC = statePickerVC
        
        prioSegmentedVC.viewModel = filterTaskViewModel
        weightSegmentedVC.viewModel = filterTaskViewModel
        reporterPickerVC.viewModel = filterTaskViewModel
        statePickerVC.viewModel = filterTaskViewModel
                
        filterTaskViewModel.screenVisible
            .filter { $0 == false }
            .subscribe(onNext: { _ in
                filterTaskVC.navigationController?.popViewController(animated: true)
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
            let vc = PrioSegmentedVC(withEmpty: false)
            return vc
        }()
        
        lazy var weightSegmentedVC: WeightSegmentedVC = {
            let vc = WeightSegmentedVC(withEmpty: false)
            return vc
        }()
        
        lazy var ownerPickerVC: TeamMemberPickerVC = {
            let vc = TeamMemberPickerVC()
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
        
        rootViewController.pushViewController(newTaskVC, animated: true)
        
        editTaskViewModel.backToTasksList
            .subscribe(onNext: { _ in
                newTaskVC.navigationController?.popViewController(animated: true)
            } )
            .disposed(by: bag)
    }

}

