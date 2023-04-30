//
//  EditTaskViewModel.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 05. 26..
//

import Foundation
import RxCocoa
import RxSwift

class EditTaskViewModel {

private let bag = DisposeBag()

// MARK: - Input

let selectedPrioSubject = PublishSubject<Int>()
let selectedWeightSubject = PublishSubject<Int>()
let selectedOwnerSubject = PublishSubject<String>()
let filledTitleSubject = PublishSubject<String>()
let filledDescriptionSubject = PublishSubject<String>()
let dialogClosed: AnyObserver<Void>


// MARK: - Output

let initialTask: Observable<InitialTaskViewModel>
let teamUser = BehaviorRelay<[TeamUser]?>(value: nil)
let presentError = BehaviorRelay<String>(value: "")
let presentCompletionWithId = BehaviorRelay<String>(value: "")
let backToTasksList: Observable<Void>

var taskNameValue: String
var desciptionValue: String
var prioValue: Int
var weightValue: Int
var creationDateValue: String
var modifiedDateValue: String
var creatorValue: String
var ownerValue: String

private let errorTrigger = PublishSubject<String>()

// MARK: - Init
init(user: User) {
    
    self.taskNameValue = ""
    self.desciptionValue = ""
    self.prioValue = 0
    self.weightValue = 0
    self.creationDateValue = ""
    self.modifiedDateValue = ""
    self.creatorValue = ""
    self.ownerValue = ""
                
    
    initialTask = Observable.deferred{
        return Observable.just(InitialTaskViewModel(user: user))
    }
    
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
    
    _ = initialTask.subscribe(onNext: { initialTask in
        self.creationDateValue = initialTask.creationDate
        self.modifiedDateValue = initialTask.modifiedDate
        self.creatorValue = initialTask.creator
    })
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
