//
//  AccountViewModel.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 02. 05..
//

import Foundation
import RxCocoa
import RxSwift

class AccountViewModel {
    
    
    // MARK: - Input
  
//    let accountBackButtonClicked: AnyObserver<Void>
    
    // MARK: - Output
    let fullName: String
    let teamName: String
    let permissions: String
    let openTicketsCount: String
    
//    let backToTasksList: Observable<Void>
    
    
    // MARK: - Init
    init(user: User) {
        self.fullName = user.fullName
        self.teamName = user.teamName

        var _permission = ""
        user.permissions.forEach { permission in
            if _permission == "" {
                _permission = permission
            } else {
                _permission = _permission + ", " + permission
            }}
        permissions = _permission
        
        openTicketsCount = String(user.userTaskID.count)
    }
    
}
