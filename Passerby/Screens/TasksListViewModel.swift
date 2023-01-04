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
    var input: BehaviorRelay<TaskItemResult> = BehaviorRelay<TaskItemResult>(value: TaskItemResult())

    // MARK: - Output
    let output = BehaviorRelay<[TaskItem]?>(value: nil)

    // MARK: - Init
    init(input: Driver<TaskItemResult>) {
//        self.input = input
    }
    
    var bag: DisposeBag = DisposeBag()
    
    func getTasks(userId: String) {
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
        self.output.accept(list)
        
    }
    
}
