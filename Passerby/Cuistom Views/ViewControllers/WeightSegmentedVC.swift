//
//  WeightSegmentedVC.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 03. 18..
//

import RxSwift
import RxCocoa
import UIKit

class WeightSegmentedVC: UIViewController {
    
    var viewModel: NewTaskViewModel!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        createWeightSegmentedControl()
    }
    
    func createWeightSegmentedControl() {
        let items = ["Low", "Medium", "High"]
        let weightSegmentedControl = UISegmentedControl(items: items)
        weightSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weightSegmentedControl)
        
        NSLayoutConstraint.activate([
            weightSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weightSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weightSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        weightSegmentedControl.rx.selectedSegmentIndex.changed
            .subscribe(viewModel.selectedWeightSubject)
            .disposed(by: bag)
    }
}
