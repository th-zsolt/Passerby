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
    
    var viewModel: WeightType!
    private let bag = DisposeBag()
    var withEmpty: Bool

    init(withEmpty: Bool) {
        self.withEmpty = withEmpty
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createWeightSegmentedControl()
    }
    
    func createWeightSegmentedControl() {
        var items: NSArray = []
        if self.withEmpty {
            items = ["", "Low", "Medium", "High"]
        } else {
            items = ["Low", "Medium", "High"]
        }
        
        let weightSegmentedControl = UISegmentedControl(items: items as? [Any])
        weightSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weightSegmentedControl)
        
        NSLayoutConstraint.activate([
            weightSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weightSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weightSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        viewModel.defaultWeightValue
            .filter { $0 != nil }
            .map { self.withEmpty ? $0! : $0!-1  }
            .subscribe(onNext: { row in
                weightSegmentedControl.selectedSegmentIndex = row
            }).disposed(by: bag)
        
        weightSegmentedControl.rx.selectedSegmentIndex.changed
            .map { self.withEmpty ? $0 : $0+1 }
            .subscribe(viewModel.selectedWeightSubject)
            .disposed(by: bag)
        
    }
}
