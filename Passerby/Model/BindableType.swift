//
//  BindableType.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 16..
//

import UIKit
import RxSwift

protocol BindableType: AnyObject {
  associatedtype ViewModelType
  var viewModel: ViewModelType! { get set }
  func bindViewModel()
}

extension BindableType where Self: UIViewController {
  func bindViewModel(to model: Self.ViewModelType) {
    viewModel = model
    loadViewIfNeeded()
    bindViewModel()
  }
}
