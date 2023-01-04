//
//  MainCoordinator.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 18..
//

import UIKit
import RxSwift

class MainCoordinator: Coordinator {
    
    var bag: DisposeBag = DisposeBag()
    
    var rootViewController = UINavigationController()
    
    
    lazy var loginVC: LoginVC = {
        let vc = LoginVC()
        return vc
    }()
    
    func start() {
                
        rootViewController.setViewControllers([loginVC], animated: false)
        
        loginVC.buttonClicked.subscribe { clicked in
            if clicked {
                print ("Igaz")
            } else {
                print ("Hamis")
            }
        }.disposed(by: bag)
    }
}
