//
//  EditTaskViewModel.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 05. 26..
//

import Foundation
import RxCocoa
import RxSwift

class EditTaskViewModel: WeightType, PrioType, TeamMemberPickerType, DialogType, StateType {

    private let bag = DisposeBag()

    // MARK: - Input
   

    let commentsButtonClicked: AnyObserver<Void>
    var dialogClosed: AnyObserver<Void>
    
    let filledTitleSubject = PublishSubject<String>()
    let filledDescriptionSubject = PublishSubject<String>()
    var selectedWeightSubject = PublishSubject<Int>()
    var selectedPrioSubject = PublishSubject<Int>()
    var selectedTeamMemberSubject = PublishSubject<String>()
    var selectedStateSubject = PublishSubject<String>()

    
    // MARK: - Output

    let originalTask = BehaviorRelay<[TaskItem]>(value: [])
    let presentError = PublishRelay<String>()
    let presentCompletionWithId = BehaviorRelay<String>(value: "")
    let presentComments = BehaviorRelay<String>(value: "")
    let backToTasksList: Observable<Void>

    var stateNames = BehaviorRelay<[String]>(value: [])
    var teamUser = BehaviorRelay<[TeamUser]?>(value: nil)
    var defaultPrioValue = BehaviorRelay<Int?>(value: nil)
    var defaultWeightValue = BehaviorRelay<Int?>(value: nil)
    var defaultTeamMemberValue = BehaviorRelay<Int?>(value: nil)
    var defaultStateValue = BehaviorRelay<Int?>(value: nil)

    var taskNameValue: String
    var desciptionValue: String
    var prioValue: Int
    var weightValue: Int
    var creationDateValue: String
    var modifiedDateValue: String
    var creatorId: String
    var creatorName: String
    var ownerId: String
    var ownerName: String
    var stateValue: Int
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
        self.creatorId = ""
        self.creatorName = ""
        self.ownerId = ""
        self.ownerName = ""
        self.stateValue = 0
        self.taskId = ""
            
        let _dialogClosed = PublishSubject<Void>()
        self.dialogClosed = _dialogClosed.asObserver()
        self.backToTasksList = _dialogClosed.asObservable()
        
        let _commentsButtonClicked = PublishSubject<Void>()
        self.commentsButtonClicked = _commentsButtonClicked.asObserver()
        _commentsButtonClicked.asObservable().subscribe(onNext: { _ in
            self.presentComments.accept(self.taskId)
        }).disposed(by: bag)
        
        self.getStates()
        
        self.getTeam(teamId: user.teamId)
        
        _ = filledTitleSubject.subscribe(onNext: { title in
            self.taskNameValue = title
        })
        
        _ = filledDescriptionSubject.subscribe(onNext: { desc in
            self.desciptionValue = desc
        })
        
        _ = selectedTeamMemberSubject.subscribe(onNext: {owner in
            self.ownerId = owner
            self.ownerName = self.getTeammemberName(id: owner, teamUsers: self.teamUser.value ?? [])
        })
        
        _ = selectedPrioSubject.subscribe(onNext: {prio in
            self.prioValue = prio
        })
        
        _ = selectedWeightSubject.subscribe(onNext: {weight in
            self.weightValue = weight
        })
        
        _ = selectedStateSubject.subscribe(onNext: {state in
            self.stateValue = Int(state) ?? 0
        })
            
        self.getTask(taskId: taskId)
        
        self.originalTask.subscribe(onNext: { taskItemList in
            self.taskNameValue = taskItemList.first?.taskName ?? ""
            self.desciptionValue = taskItemList.first?.description ?? ""
            self.prioValue = taskItemList.first?.taskPrio ?? 0
            self.weightValue = taskItemList.first?.taskWeight ?? 0
            self.creationDateValue = taskItemList.first?.creationDate ?? ""
            self.modifiedDateValue = taskItemList.first?.modifiedDate ?? ""
            self.creatorId = taskItemList.first?.creatorId ?? ""
            self.creatorName = taskItemList.first?.creator ?? ""
            self.ownerId = taskItemList.first?.assignedId ?? ""
            self.ownerName = taskItemList.first?.assigned ?? ""
            self.stateValue = taskItemList.first?.state ?? 0
            self.taskId = taskItemList.first?.taskId ?? ""
            self.setDefaultPrioValue()
            self.setDefaultWeightValue()
            self.setDefaultOwnerValue()
            self.setDefaultStateValue()
        }).disposed(by: bag)
        
    }
    
    func setDefaultPrioValue() {
        let _prioValue = self.prioValue
        let _defaultPrioValue: Int = _prioValue
        self.defaultPrioValue.accept(_defaultPrioValue)
    }
    
    
    func setDefaultWeightValue() {
        let _weightValue = self.weightValue
        let _defaultWeightValue: Int = _weightValue
        self.defaultWeightValue.accept(_defaultWeightValue)
    }
    
    
    func setDefaultOwnerValue() {
        guard let teamusers = self.teamUser.value else { return }
        let _defaultOwnerValue = teamusers.firstIndex(where: {$0.userId == self.ownerId})
        self.defaultTeamMemberValue.accept(_defaultOwnerValue)
    }
    
    
    func setDefaultStateValue() {
        let _stateValue = self.stateValue
        let _defaultStateValue: Int = _stateValue
        self.defaultStateValue.accept(_defaultStateValue)
    }

    
    func getTask(taskId: String) {
        ApiClient.getTask(taskId: taskId).asObservable().subscribe(
            onNext: { result in
                self.originalTask.accept([result])
        }, onError: { error in
            let errorMessage = ErrorHelper.parseErroMessage(error: error)
            self.presentError.accept(errorMessage)
        }).disposed(by: bag)
    }
    
    
    func getStates() {
        let states = TaskState().state.map { "\($0.value)" }
        self.stateNames.accept(states)
    }

    
    func modifyTask() {
        if ownerId == "" {getDefaultOwner()}
        let modifiedTask = TaskItem(taskId: taskId,
                                    taskName: taskNameValue,
                                    taskPrio: prioValue,
                                    taskWeight: weightValue,
                                    creationDate: creationDateValue,
                                    modifiedDate: modifiedDateValue,
                                    creator: creatorName,
                                    creatorId: creatorId,
                                    assigned: ownerName,
                                    assignedId: ownerId,
                                    description: desciptionValue,
                                    state: stateValue)
        print(modifiedTask)
        
        ApiClient.modifyTask(taskItem: modifiedTask).asObservable().subscribe(
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
        return Observable.combineLatest(filledTitleSubject.asObservable(), filledDescriptionSubject.asObservable()).map { title, desc in
            return title.count > 3 && desc.count > 3
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
    
    func getTeammemberName(id: String, teamUsers: [TeamUser]) -> String {
        return teamUsers.filter { $0.userId == id}.first?.userName ?? ""
        }
    
}
