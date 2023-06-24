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
    
    private let bag = DisposeBag()
    
    // MARK: - Input
    let loginName: AnyObserver<String>
    
    // MARK: - Output
    let user = BehaviorRelay<User?>(value: nil)

    // MARK: - Init
                        
    init() {
        let _loginName = PublishSubject<String>()
        self.loginName = _loginName.asObserver()
    }
    
    
    func getUser(loginName: String) {
        print(loginName)
        ApiClient.getUser(loginName: loginName).asObservable().subscribe(
            onNext: { result in
                self.user.accept(result)
        }, onError: { error in
            print(error)
        }).disposed(by: bag)
    }
}
