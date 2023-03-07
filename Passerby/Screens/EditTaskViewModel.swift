//
//  EditTaskViewModel.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 03. 12..
//

import Foundation
import RxCocoa
import RxSwift

class EditTaskViewModel {
    
    
    // MARK: - Input
    
//    let selectedPrioValue : AnyObserver<Int>
    let selectedPrioValueSubject = PublishSubject<Int>()

    
//    private let selectedPrioValueSubject = BehaviorSubject<Int>(value: 0)

    
    // MARK: - Output
    
    let creationDate: String
    let modifiedDate: String
    let creator: String
    let prioValue: Driver<Int>
    
//    let isPrioEntered: Bool
    
    //    let backToTasksList: Observable<Void>
    
    
    // MARK: - Init
    init(user: User) {
        self.creationDate = Date().convertToMonthYearFormat()
        self.modifiedDate = Date().convertToMonthYearFormat()
        self.creator = user.fullName
        
//        let _selectedPrioValue = PublishSubject<Int>()
//        self.selectedPrioValue = _selectedPrioValue.asObserver()

//        self.selectedPrioValue = selectedPrioValueSubject.asObserver()
        self.prioValue = self.selectedPrioValueSubject
            .asObservable()
            .asDriver(onErrorJustReturn: 0)
        
//        _ = selectedPrioValueSubject.asObserver()
//            .subscribe( onNext: { teszt in
//                print(teszt)
//            })
    }
    
    
    
//    func onCreateTask() -> TaskItem {
//        let taskId: String
//        let taskName: String
//        let taskPrio: Int
//        let taskWeight: Int
//        let assigned: String
//        let description: String
//        
//        taskId = "01"
//        
//    }
}
