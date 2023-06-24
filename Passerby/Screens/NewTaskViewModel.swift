//
//  EditTaskViewModel.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 03. 12..
//

import Foundation
import RxCocoa
import RxSwift

class NewTaskViewModel: WeightType, PrioType, TeamMemberPickerType, DialogType {
    
    private let bag = DisposeBag()
    
    // MARK: - Input
    
    let filledTitleSubject = PublishSubject<String>()
    let filledDescriptionSubject = PublishSubject<String>()
    
    var dialogClosed: AnyObserver<Void>
    var selectedWeightSubject = PublishSubject<Int>()
    var selectedPrioSubject = PublishSubject<Int>()
    var selectedTeamMemberSubject = PublishSubject<String>()
    
    
    // MARK: - Output
    
    let initialTask: Observable<InitialTask>
    let presentError = PublishRelay<String>()
    let presentCompletionWithId = BehaviorRelay<String>(value: "")
    let backToTasksList: Observable<Void>
    
    var teamUser = BehaviorRelay<[TeamUser]?>(value: nil)
    var defaultPrioValue = BehaviorRelay<Int?>(value: nil)
    var defaultWeightValue = BehaviorRelay<Int?>(value: nil)
    var defaultTeamMemberValue = BehaviorRelay<Int?>(value: nil)
    
    var taskNameValue: String
    var desciptionValue: String
    var prioValue: Int
    var weightValue: Int
    var creationDateValue: String
    var modifiedDateValue: String
    var creatorId: String
    var creatorValue: String
    var ownerId: String
    
    private let errorTrigger = PublishSubject<String>()
    
    // MARK: - Init
    init(user: User) {
        
        self.taskNameValue = ""
        self.desciptionValue = ""
        self.prioValue = 0
        self.weightValue = 0
        self.creationDateValue = ""
        self.modifiedDateValue = ""
        self.creatorId = ""
        self.creatorValue = ""
        self.ownerId = ""
        
        initialTask = Observable.deferred{
            return Observable.just(InitialTask(user: user))
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
        
        _ = selectedTeamMemberSubject.subscribe(onNext: {owner in
            self.ownerId = owner
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
            self.creatorId = initialTask.creatorId
            self.creatorValue = initialTask.creatorName
        })
        
    }
    
    
    func createTask() {

        
        if ownerId == "" {getDefaultOwner()}
        let newTask = NewTask(taskName: taskNameValue,
                              taskPrio: prioValue,
                              taskWeight: weightValue,
                              creationDate: creationDateValue,
                              modifiedDate: modifiedDateValue,
                              creatorId: creatorId,
                              assignedId: ownerId,
                              description: desciptionValue)
        print(newTask)
        
        ApiClient.createTask(newTask: newTask).asObservable().subscribe(
            onNext: { id in
                self.presentCompletionWithId.accept(id)
            }, onError: { error in
                let errorMessage = ErrorHelper.parseErroMessage(error: error)
                self.presentError.accept(errorMessage)
            }).disposed(by: bag)
    }
    
        
    
    func getDefaultOwner() {
        _ = teamUser.subscribe(onNext: { teamUser in
            self.ownerId = String(teamUser?.first?.userId ?? "")
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
            let errorMessage = ErrorHelper.parseErroMessage(error: error)
            self.presentError.accept(errorMessage)
        }).disposed(by: bag)
    }
    
    
    func mapTeamUser(team: Team) {
        let teamUser: [TeamUser] = team.teamUser
        self.teamUser.accept(teamUser)
    }
        
}

