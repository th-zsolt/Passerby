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
    var selectedTeamMemberSubject = PublishSubject<String>()
    var selectedStateSubject = PublishSubject<String>()
    let doFilterButtonClicked = PublishSubject<Void>()
    
    // MARK: - Output
    
    var doFilter = BehaviorRelay<FilterItem?>(value: nil)
    var screenVisible = BehaviorRelay<Bool>(value: false)
    var teamUser = BehaviorRelay<[TeamUser]?>(value: nil)
    let presentError = PublishRelay<String>()
    var stateNames = BehaviorRelay<[String]>(value: [])
    
    var defaultPrioValue = BehaviorRelay<Int?>(value: nil)
    var defaultWeightValue = BehaviorRelay<Int?>(value: nil)
    var defaultTeamMemberValue = BehaviorRelay<Int?>(value: nil)
    var defaultStateValue = BehaviorRelay<Int?>(value: nil)
        
    var filterItem : FilterItem
    var taskId: String
    var taskNameValue: String
    var desciptionValue: String
    var prioValue: Int
    var weightValue: Int
    var creatorValue: String
    var stateValue: Int

    
// MARK: - Init
    init(user: User) {
                
        self.filterItem = FilterItem()
        self.taskId = self.filterItem.taskId
        self.taskNameValue = self.filterItem.taskName
        self.desciptionValue = self.filterItem.description
        self.prioValue = self.filterItem.taskPrio
        self.weightValue = self.filterItem.taskWeight
        self.creatorValue = self.filterItem.creatorId
        self.stateValue = self.filterItem.state
                
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
        
        _ = selectedTeamMemberSubject.subscribe(onNext: {creator in
            self.creatorValue = creator
        })

        _ = selectedPrioSubject.subscribe(onNext: {prio in
            (prio == 0) ? (self.prioValue = -1) : (self.prioValue = prio)
        })

        _ = selectedWeightSubject.subscribe(onNext: {weight in
            (weight == 0) ? (self.weightValue = -1) : (self.weightValue = weight)
        })

        _ = selectedStateSubject.subscribe(onNext: {state in
            self.stateValue = Int(state) ?? 0
        })
        
        self.doFilterButtonClicked
            .asObservable()
            .subscribe(onNext: { _ in
                self.filterItem = self.setFilterItem()
                self.doFilter.accept( self.filterItem)
                self.screenVisible.accept(false)
                self.setDefaultPrioValue()
                self.setDefaultWeightValue()
                self.setDefaultReporterValue()
                self.setDefaultStateValue()
                })
            .disposed(by: bag)
        
        self.setDefaultPrioValue()
        self.setDefaultWeightValue()
        self.setDefaultReporterValue()
        self.setDefaultStateValue()
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
        self.defaultTeamMemberValue.accept(0)
        
        self.taskId = ""
        self.taskNameValue = ""
        self.desciptionValue = ""
        self.prioValue = -1
        self.weightValue = -1
        self.creatorValue = "0"
        self.stateValue = 0
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
    
    
    func setDefaultReporterValue() {
        guard let teamusers = self.teamUser.value else { return }
        let _defaultReporterValue = teamusers.firstIndex(where: {$0.userId == self.creatorValue})
        self.defaultTeamMemberValue.accept(_defaultReporterValue)
    }
    
    
    func setDefaultStateValue() {
        let _stateValue = self.stateValue
        let _defaultStateValue: Int = _stateValue
        self.defaultStateValue.accept(_defaultStateValue)
    }
}
