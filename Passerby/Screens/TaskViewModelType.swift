//
//  TaskViewModelType.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 05. 28..
//

import Foundation
import RxCocoa
import RxSwift

protocol TaskViewModelType {
    
    
    // MARK: - Input
    var selectedWeightSubject: PublishSubject<Int> { get }
    var selectedPrioSubject: PublishSubject<Int> { get }
    var selectedOwnerSubject: PublishSubject<String> { get }
    var dialogClosed: AnyObserver<Void> { get set }
    
    
    // MARK: - Output
    var teamUser: BehaviorRelay<[TeamUser]?> { get set }
    var defaultPrioValue: BehaviorRelay<Int?> { get set }
    var defaultWeightValue: BehaviorRelay<Int?> { get set }
    var defaultOwnerValue: BehaviorRelay<Int?> { get set }
}
