//
//  EditTaskViewModel.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 05. 26..
//

import Foundation
import RxCocoa
import RxSwift

class EditTaskViewModel: TaskViewModelType {

    private let bag = DisposeBag()

    // MARK: - Input
   
    let filledTitleSubject = PublishSubject<String>()
    let filledDescriptionSubject = PublishSubject<String>()
        
    var dialogClosed: AnyObserver<Void>
    var selectedWeightSubject = PublishSubject<Int>()
    var selectedPrioSubject = PublishSubject<Int>()
    var selectedOwnerSubject = PublishSubject<String>()

    
    // MARK: - Output

    let originalTask = BehaviorRelay<[TaskItem]>(value: [])
    let presentError = BehaviorRelay<String>(value: "")
    let presentCompletionWithId = BehaviorRelay<String>(value: "")
    let backToTasksList: Observable<Void>
    
    var teamUser = BehaviorRelay<[TeamUser]?>(value: nil)
    var defaultPrioValue = BehaviorRelay<Int?>(value: nil)
    var defaultWeightValue = BehaviorRelay<Int?>(value: nil)
    var defaultOwnerValue = BehaviorRelay<Int?>(value: nil)

    var taskNameValue: String
    var desciptionValue: String
    var prioValue: Int
    var weightValue: Int
    var creationDateValue: String
    var modifiedDateValue: String
    var creatorValue: String
    var ownerValue: String
    var taskId: String

    private let errorTrigger = PublishSubject<String>()

// MARK: - Init
    init(user: User, taskId: String) {
        
        self.taskNameValue = ""
        self.desciptionValue = ""
        self.prioValue = 0
        self.weightValue = 0
        self.creationDateValue = ""
        self.modifiedDateValue = ""
        self.creatorValue = ""
        self.ownerValue = ""
        self.taskId = ""
            
        let _dialogClosed = PublishSubject<Void>()
        self.dialogClosed = _dialogClosed.asObserver()
        self.backToTasksList = _dialogClosed.asObservable()
        
        self.getTeam(teamId: user.teamId)
        
        _ = filledTitleSubject.subscribe(onNext: { title in
            self.taskNameValue = title
        })
        
        _ = filledDescriptionSubject.subscribe(onNext: { desc in
            self.desciptionValue = desc
        })
        
        _ = selectedOwnerSubject.subscribe(onNext: {owner in
            self.ownerValue = owner
        })
        
        _ = selectedPrioSubject.subscribe(onNext: {prio in
            self.prioValue = prio
        })
        
        _ = selectedWeightSubject.subscribe(onNext: {weight in
            self.weightValue = weight
        })
            
        self.getTask(taskId: taskId)
        
        self.originalTask.subscribe(onNext: { taskItemList in
            self.taskNameValue = taskItemList.first?.taskName ?? ""
            self.desciptionValue = taskItemList.first?.description ?? ""
            self.prioValue = taskItemList.first?.taskPrio ?? 0
            self.weightValue = taskItemList.first?.taskWeight ?? 0
            self.creationDateValue = taskItemList.first?.creationDate ?? ""
            self.modifiedDateValue = taskItemList.first?.modifiedDate ?? ""
            self.creatorValue = taskItemList.first?.creator ?? ""
            self.ownerValue = taskItemList.first?.assigned ?? ""
            self.taskId = taskItemList.first?.assigned ?? ""
            self.setDefaultPrioValue()
            self.setDefaultWeightValue()
            self.setDefaultOwnerValue()
        }).disposed(by: bag)
        
    }
    
    func setDefaultPrioValue() {
        let _prioValue = self.prioValue - 1
        let _defaultPrioValue: Int = _prioValue
        self.defaultPrioValue.accept(_defaultPrioValue)
    }
    
    
    func setDefaultWeightValue() {
        let _weightValue = self.weightValue - 1
        let _defaultWeightValue: Int = _weightValue
        self.defaultWeightValue.accept(_defaultWeightValue)
    }
    
    func setDefaultOwnerValue() {
        guard let teamusers = self.teamUser.value else { return }
        let _defaultOwnerValue = teamusers.firstIndex(where: {$0.userName == self.ownerValue})
        self.defaultOwnerValue.accept(_defaultOwnerValue)
    }

    
    func getTask(taskId: String) {
        ApiClient.getTask(taskId: taskId).asObservable().subscribe(
            onNext: { result in
                self.originalTask.accept([result])
        }, onError: { error in
            print(error)
        }).disposed(by: bag)
    }
    

    func createTask() {
        if ownerValue == "" {getDefaultOwner()}
        let newTask = NewTask(taskName: taskNameValue,
                              taskPrio: prioValue,
                              taskWeight: weightValue,
                              creationDate: creationDateValue,
                              modifiedDate: modifiedDateValue,
                              creator: creatorValue,
                              assigned: ownerValue,
                              description: desciptionValue)
        print(newTask)
        
        ApiClient.createTask(newTask: newTask).asObservable().subscribe(
            onNext: { id in
                self.presentCompletionWithId.accept(id)
            }, onError: { error in
                self.presentError.accept(error.localizedDescription)
            }).disposed(by: bag)
    }

    
    func getDefaultOwner() {
        _ = teamUser.subscribe(onNext: { teamUser in
            self.ownerValue = String(teamUser?.first?.userId ?? "")
            })
            .disposed(by: bag)
    }


    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(selectedPrioSubject.asObservable(), selectedWeightSubject.asObservable(),  filledTitleSubject.asObservable(), filledDescriptionSubject.asObservable()).map { prio, weight, title, desc in
            return prio >= 0 && weight >= 0 && title.count > 3 && desc.count > 3
        }
    }


    func getTeam(teamId: String) {
        ApiClient.getTeam(teamID: teamId).asObservable().subscribe(
            onNext: { team in
                self.mapTeamUser(team: team)
        }, onError: { error in
            self.presentError.accept(error.localizedDescription)
        }).disposed(by: bag)
    }


    func mapTeamUser(team: Team) {
        let teamUser: [TeamUser] = team.teamUser
        self.teamUser.accept(teamUser)
    }
    
}
