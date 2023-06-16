//
//  TasksListViewModel.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 08..
//

import Foundation
import RxCocoa
import RxSwift

class TasksListViewModel {

    var bag: DisposeBag = DisposeBag()
        
    // MARK: - Input
    
    let user: Driver<User>
    let accountButtonClicked: AnyObserver<Void>
    let filterButtonClicked: AnyObserver<Void>
    let addButtonClicked: AnyObserver<Void>
    let taskItemSelected = PublishSubject<Int>()
    let doFilterTaskList = PublishSubject<FilterItem?>()

    // MARK: - Output
    
    let filteredTaskItems = BehaviorRelay<[TaskItem]?>(value: nil)
    let showAccount: Observable<Void>
    let showFilter: Observable<Void>
    let showNewTask: Observable<Void>
    let showEditTask = BehaviorRelay<String>(value: "")
    
    private var originalTaskItems = [TaskItem]?(nil)
    private var filterItem : FilterItem

    // MARK: - Init
    init(user: Driver<User>) {
        
        self.filterItem = FilterItem()
        
        let _accountButtonClicked = PublishSubject<Void>()
        self.accountButtonClicked = _accountButtonClicked.asObserver()
        self.showAccount = _accountButtonClicked.asObservable()
        
        let _filterButtonClicked = PublishSubject<Void>()
        self.filterButtonClicked = _filterButtonClicked.asObserver()
        self.showFilter = _filterButtonClicked.asObservable()
        
        let _addButtonClicked = PublishSubject<Void>()
        self.addButtonClicked = _addButtonClicked.asObserver()
        self.showNewTask = _addButtonClicked.asObservable()
                
        self.user = user
        _ = user
            .asObservable().subscribe(onNext: { _user in
                self.getTasks(userId: _user.userId)
            })
        
        self.taskItemSelected
            .subscribe(onNext: { indexPath in
                if indexPath != -1 { self.loadTaskEditor(indexPath: indexPath) }
            }).disposed(by: bag)
        
        self.doFilterTaskList
            .filter{ $0 != nil }
            .subscribe(onNext: { _filterItem in
                self.filterItem = _filterItem!
                self.filterTask()
            }).disposed(by: bag)
        
        }
    
    
    func loadTaskEditor(indexPath: Int) {
        self.showEditTask.accept(self.filteredTaskItems.value![indexPath].taskId)
//        print(self.taskItems.value![indexPath].taskId)
    }
       
    
    func getTasks(userId: String) {
        print(userId)
        ApiClient.getTasks(userId: userId).asObservable().subscribe(
            onNext: { result in
                self.originalTaskItems = result.taskItems
                self.filterTask()
        }, onError: { error in
            print(error)
        }).disposed(by: bag)
    }
    
    
//    func mapTasks(result: TaskItemResult) {
//
//        let list: [TaskItem] = result.taskItems
//        self.filteredTaskItems.accept(list)
//    }
    
    func filterTask() {
        if originalTaskItems != nil {
            print(self.originalTaskItems)
            print(self.filterItem)
            var _filteredTaskItem = originalTaskItems
            if self.filterItem.taskId != "" { _filteredTaskItem = _filteredTaskItem?.filter {
                $0.taskId == self.filterItem.taskId
            } }
            if self.filterItem.taskName != "" { _filteredTaskItem = _filteredTaskItem?.filter {
                $0.taskName.contains(self.filterItem.taskName)
            } }
            if self.filterItem.description != "" { _filteredTaskItem = _filteredTaskItem?.filter {
                $0.description.contains(self.filterItem.description)
            } }
            if self.filterItem.taskPrio != -1 { _filteredTaskItem = _filteredTaskItem?.filter {
                $0.taskPrio == self.filterItem.taskPrio
            } }
            if self.filterItem.taskWeight != -1 { _filteredTaskItem = _filteredTaskItem?.filter {
                $0.taskWeight == self.filterItem.taskWeight
            } }
            if self.filterItem.creatorId != "" && self.filterItem.creatorId != "0" { _filteredTaskItem = _filteredTaskItem?.filter {
                $0.creatorId.contains(self.filterItem.creatorId)
            } }
            if self.filterItem.state != 0 && self.filterItem.state != -1 { _filteredTaskItem = _filteredTaskItem?.filter {
                $0.state == self.filterItem.state
            } }
            self.filteredTaskItems.accept(_filteredTaskItem)
        }
    }
    
}
