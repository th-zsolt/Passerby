//
//  Protocols.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 06. 13..
//

import Foundation
import RxCocoa
import RxSwift

protocol WeightType {
    var selectedWeightSubject: PublishSubject<Int> { get }
    var defaultWeightValue: BehaviorRelay<Int?> { get set }
}

protocol PrioType {
    var selectedPrioSubject: PublishSubject<Int> { get }
    var defaultPrioValue: BehaviorRelay<Int?> { get set }
}

protocol TeamMemberPickerType {
    var teamUser: BehaviorRelay<[TeamUser]?> { get set }
    var selectedOwnerSubject: PublishSubject<String> { get }
    var defaultOwnerValue: BehaviorRelay<Int?> { get set }
}

protocol StateType {
    var stateNames: BehaviorRelay<[String]> { get set }
    var selectedStateSubject: PublishSubject<String> { get }
    var defaultStateValue: BehaviorRelay<Int?> { get set }
}

protocol DialogType {
    var dialogClosed: AnyObserver<Void> { get set }
}
    





    



