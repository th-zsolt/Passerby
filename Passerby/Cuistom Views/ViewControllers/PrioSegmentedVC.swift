//
//  PrioSegmentedVC.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 03. 12..
//
import RxSwift
import RxCocoa
import UIKit

class PrioSegmentedVC: UIViewController {

    var viewModel: PrioType!
    private let bag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        createPrioSegmentedControl()
    }
    
    
    func createPrioSegmentedControl() {
        let items = ["Low", "Medium", "High"]
        let prioSegmentedControl = UISegmentedControl(items: items)

        prioSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(prioSegmentedControl)
        
        NSLayoutConstraint.activate([
            prioSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            prioSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            prioSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        ])
     
        prioSegmentedControl.rx.selectedSegmentIndex.changed
            .subscribe(viewModel.selectedPrioSubject)
            .disposed(by: bag)
        
        viewModel.defaultPrioValue
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { row in
                prioSegmentedControl.selectedSegmentIndex = row
            }).disposed(by: bag)
    }
    
}
