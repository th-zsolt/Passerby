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

        
    // MARK: - Input
    let user: Driver<User>
    
    let accountButtonClicked: AnyObserver<Void>

    // MARK: - Output
    let taskItems = BehaviorRelay<[TaskItem]?>(value: nil)
    
    let showAccount: Observable<Void>
    
//    let showFilter: Observable<Void>
//
//    let showAddTask: Observable<Void>
//
//    let showSelectedTask: Observable<Void>

    // MARK: - Init
    init(user: Driver<User>) {
        
        let _accountButtonClicked = PublishSubject<Void>()
        self.accountButtonClicked = _accountButtonClicked.asObserver()
        self.showAccount = _accountButtonClicked.asObservable()
        
        self.user = user
        _ = user
            .asObservable().subscribe(onNext: { _user in
                self.getTasks(userId: _user.userId)
            })
    }
        
    var bag: DisposeBag = DisposeBag()
    
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
    
    
    func accountButtonPushed() {
        
    }
    
}
