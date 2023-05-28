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
    
    var viewModel: TaskViewModelType!
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
        
        viewModel.defaultWeightValue
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { row in
                weightSegmentedControl.selectedSegmentIndex = row
            }).disposed(by: bag)
    }
}
