//
//  EditTaskViewModel.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 03. 12..
//

import Foundation
import RxCocoa
import RxSwift

class NewTaskViewModel {
    
    private let bag = DisposeBag()
    
    // MARK: - Input
    
    let selectedPrioSubject = PublishSubject<Int>()
    let selectedWeightSubject = PublishSubject<Int>()
    let selectedOwnerSubject = PublishSubject<String>()
    let filledTitleSubject = PublishSubject<String>()
    let filledDescriptionSubject = PublishSubject<String>()
        
    
    // MARK: - Output
    
    let initialTask: Observable<InitialTaskViewModel>
    let teamUser = BehaviorRelay<[TeamUser]?>(value: nil)
    
    var taskNameValue: String
    var desciptionValue: String
    var prioValue: Int
    var weightValue: Int
    var creationDateValue: String
    var modifiedDateValue: String
    var creatorValue: String
    var ownerValue: String

    
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
        let newTask = TaskItem(taskId: "0",
                               taskName: taskNameValue,
                               taskPrio: prioValue,
                               taskWeight: weightValue,
                               creationDate: creationDateValue,
                               modifiedDate: modifiedDateValue,
                               creator: creatorValue,
                               assigned: ownerValue,
                               description: desciptionValue)
        print(newTask)
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
            print(error)
        }).disposed(by: bag)
    }
    
    
    func mapTeamUser(team: Team) {
        let teamUser: [TeamUser] = team.teamUser
        self.teamUser.accept(teamUser)
    }
        
}

struct InitialTaskViewModel {
    let creationDate: String
    let modifiedDate: String
    let creator: String
}

extension InitialTaskViewModel {
    init(user: User) {
        self.creationDate = Date().convertToDayMonthYearFormat()
        self.modifiedDate = Date().convertToDayMonthYearFormat()
        self.creator = user.fullName
    }
}
