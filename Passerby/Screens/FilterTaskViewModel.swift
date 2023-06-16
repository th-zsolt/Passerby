//
//  FilterTaskViewModel.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 06. 13..
//

import Foundation
import RxCocoa
import RxSwift

class FilterTaskViewModel: WeightType, PrioType, TeamMemberPickerType, StateType  {
    
    private let bag = DisposeBag()
    
    // MARK: - Input
    
    let filledTitleSubject = PublishSubject<String>()
    let filledDescriptionSubject = PublishSubject<String>()
    let filledIdSubject = PublishSubject<String>()
    
    var selectedWeightSubject = PublishSubject<Int>()
    var selectedPrioSubject = PublishSubject<Int>()
    var selectedOwnerSubject = PublishSubject<String>()
    var selectedStateSubject = PublishSubject<String>()
    let doFilterButtonClicked = PublishSubject<Void>()
    
    // MARK: - Output
    
    var doFilter = BehaviorRelay<FilterItem?>(value: nil)
    var screenVisible = BehaviorRelay<Bool>(value: false)
    var teamUser = BehaviorRelay<[TeamUser]?>(value: nil)
    let presentError = BehaviorRelay<String>(value: "")
    var stateNames = BehaviorRelay<[String]>(value: [])
    
    var defaultPrioValue = BehaviorRelay<Int?>(value: nil)
    var defaultWeightValue = BehaviorRelay<Int?>(value: nil)
    var defaultOwnerValue = BehaviorRelay<Int?>(value: nil)
    var defaultStateValue = BehaviorRelay<Int?>(value: nil)
    
    var taskId: String
    var taskNameValue: String
    var desciptionValue: String
    var prioValue: Int
    var weightValue: Int
    var creatorValue: String
    var stateValue: Int

    
// MARK: - Init
    init(user: User) {
        
        self.taskId = ""
        self.taskNameValue = ""
        self.desciptionValue = ""
        self.prioValue = -1
        self.weightValue = -1
        self.creatorValue = "0"
        self.stateValue = 0
                
        self.getStates()
                        
        self.getTeam(teamId: user.teamId)
        
        _ = filledTitleSubject.subscribe(onNext: { title in
            self.taskNameValue = title
        })
        
        _ = filledDescriptionSubject.subscribe(onNext: { desc in
            self.desciptionValue = desc
        })
        
        _ = filledIdSubject.subscribe(onNext: { id in
            self.taskId = id
        })
        
        _ = selectedOwnerSubject.subscribe(onNext: {owner in
            self.creatorValue = owner
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
        
        self.doFilterButtonClicked
            .asObservable()
            .subscribe(onNext: { _ in
                self.doFilter.accept( self.setFilterItem())
                self.screenVisible.accept(false)
                })
            .disposed(by: bag)
    }

    
    func setFilterItem() -> FilterItem {
        return {
            FilterItem(taskId: self.taskId,
                       taskName: self.taskNameValue,
                       description: self.desciptionValue,
                       taskPrio: self.prioValue,
                       taskWeight: self.weightValue,
                       creator: self.creatorValue,
                       state: self.stateValue)
        }()
    }
    
    
    func resetFilter() {
        self.defaultPrioValue.accept(-1)
        self.defaultWeightValue.accept(-1)
        self.defaultStateValue.accept(0)
        self.defaultOwnerValue.accept(0)
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
        var teamUser: [TeamUser] = team.teamUser
        teamUser = addEmptyFilterToTeamUser(teamuser: teamUser)
        self.teamUser.accept(teamUser)
    }
    
    func addEmptyFilterToTeamUser(teamuser: [TeamUser]) -> [TeamUser] {
        var _teamuser = teamuser
        _teamuser.insert(TeamUser(userId: "0", userName: ""), at: 0)
        return _teamuser
    }
    
    func getStates() {
        var states = TaskState().state.map { "\($0.value)" }
        states = addEmptyFilterToStateNames(stateNames: states)
        self.stateNames.accept(states)
    }
    
    func addEmptyFilterToStateNames(stateNames: [String]) -> [String] {
        var _stateNames = stateNames
        _stateNames.insert("", at: 0)
        return _stateNames
    }
    
    func FilterTaskItems() -> (Bool) {
        

        return true
    }

}
