//
//  LoginCoordinator.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 21..
//

import UIKit
import RxSwift
import RxCocoa

class LoginCoordinator: Coordinator {
    weak var parentCoordinator: MainCoordinator?
    var bag: DisposeBag = DisposeBag()
    var rootViewController = UINavigationController()
    
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    func start() {
        lazy var loginVC: LoginVC = {
            let vc = LoginVC()
            return vc
        }()
        
        let viewModel = LoginViewModel()
        loginVC.viewModel = viewModel
        rootViewController.setViewControllers([loginVC], animated: false)
          
        
        loginVC.viewModel.user
            .subscribe(onNext: { user in
                if user != nil {
                    self.parentCoordinator?.loadTasksList(user: user!) }
            })
            .disposed(by: bag)
        
//        loginVC.buttonClicked
//            .subscribe(onNext: { _ in self.parentCoordinator?.loadTasksList() })
//            .disposed(by: bag)
    }
}

