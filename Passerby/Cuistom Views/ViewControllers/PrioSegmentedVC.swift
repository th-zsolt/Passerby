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
        createPrioSegmentedControl()
    }
    
    
    func createPrioSegmentedControl() {
        var items: NSArray = []
        if self.withEmpty {
            items = ["", "Low", "Medium", "High"]
        } else {
            items = ["Low", "Medium", "High"]
        }
        
        let prioSegmentedControl = UISegmentedControl(items: items as? [Any])

        prioSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(prioSegmentedControl)
        
        NSLayoutConstraint.activate([
            prioSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            prioSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            prioSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        ])
     
        viewModel.defaultPrioValue
            .filter { $0 != nil }
            .map { self.withEmpty ? $0! : $0!-1  }
            .subscribe(onNext: { row in
                prioSegmentedControl.selectedSegmentIndex = row
            }).disposed(by: bag)
        
        prioSegmentedControl.rx.selectedSegmentIndex.changed
            .map { self.withEmpty ? $0 : $0+1 }
            .subscribe(viewModel.selectedPrioSubject)
            .disposed(by: bag)
        
    }
    
}
