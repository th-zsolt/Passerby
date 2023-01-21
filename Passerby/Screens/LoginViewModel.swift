//
//  LoginViewModel.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 15..
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel {

//    let dummyUser: Observable<User>
    let dummyUser = Observable.of(User(userId: "1", loginName: "Test1", fullName: "Teszt Elek", userTaskID: ["1","2","3"]))
                              
    init() {
//        self.dummyUser = dummyUser
    }
    
    
    
}
