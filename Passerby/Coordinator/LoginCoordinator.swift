//
//  LoginCoordinator.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 21..
//

//import UIKit
//import RxSwift
//import RxCocoa
//
//class LoginCoordinator: Coordinator {
//    
//    var bag: DisposeBag = DisposeBag()
//    
//    var rootViewController = UINavigationController()
//        
//    lazy var loginVC: LoginVC = {
//        let vc = LoginVC()
//        return vc
//    }()
//    
//    
//    func start() {
//        
//        let viewModel = LoginViewModel()
//                
//        rootViewController.setViewControllers([loginVC], animated: false)
//        
//        let taskListVC  = TasksListVC()
//        navigationController.pushViewController(taskListVC, animated: true)
//    }
//}
