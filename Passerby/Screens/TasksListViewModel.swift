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
    let addButtonClicked: AnyObserver<Void>
    let taskItemSelected = PublishSubject<Int>()

    // MARK: - Output
    
    let taskItems = BehaviorRelay<[TaskItem]?>(value: nil)
    let showAccount: Observable<Void>
//    let showFilter: Observable<Void>
    let showNewTask: Observable<Void>
    let showEditTask = BehaviorRelay<String>(value: "")

    // MARK: - Init
    init(user: Driver<User>) {
        
        let _accountButtonClicked = PublishSubject<Void>()
        self.accountButtonClicked = _accountButtonClicked.asObserver()
        self.showAccount = _accountButtonClicked.asObservable()
        
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
                if indexPath != -1 {                      self.loadTaskEditor(indexPath: indexPath) }
            }).disposed(by: bag)
        }
    
    
    func loadTaskEditor(indexPath: Int) {
        self.showEditTask.accept(self.taskItems.value![indexPath].taskId)
//        print(self.taskItems.value![indexPath].taskId)
    }
       
    
    func getTasks(userId: String) {
        print(userId)
        ApiClient.getTasks(userId: userId).asObservable().subscribe(
            onNext: { result in
                self.mapTasks(result: result)
//            print(result)
        }, onError: { error in
            print(error)
        }).disposed(by: bag)
    }
    
    
    func mapTasks(result: TaskItemResult) {
        
        let list: [TaskItem] = result.taskItems
        self.taskItems.accept(list)
    }
    
    
//    func accountButtonPushed() {
//
//    }
    
}
