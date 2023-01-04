//
//  Scene+ViewController.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 15..
//

//import UIKit
//
//extension Scene {
//  func viewController() -> UIViewController {
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    switch self {
//    case .login(let viewModel):
//      let nc = storyboard.instantiateViewController(withIdentifier: "Login") as! UINavigationController
//      let vc = nc.viewControllers.first as! LoginVC
//      vc.bindViewModel(to: viewModel)
//      return nc
//
//    case .taskList(let viewModel):
//      let nc = storyboard.instantiateViewController(withIdentifier: "TasksList") as! UINavigationController
//      let vc = nc.viewControllers.first as! TasksListVC
//      vc.bindViewModel(to: viewModel)
//      return nc
//    }
//  }
//}
