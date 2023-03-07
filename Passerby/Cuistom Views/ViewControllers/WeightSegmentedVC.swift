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
    
    var viewModel: EditTaskViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        createWeightSegmentedControl()
    }
    
    func createWeightSegmentedControl() {
        let items = ["Low", "Medium", "High"]
        let weightSegmentedControl = UISegmentedControl(items: items)
        weightSegmentedControl.addTarget(self, action: #selector(weightDidChange(_:)), for: .valueChanged)
        weightSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weightSegmentedControl)
        
        NSLayoutConstraint.activate([
            weightSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weightSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weightSegmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }

    @objc func weightDidChange(_ segmentedControl: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("Low")
        case 1:
            print("Medium")
        case 2:
            print("High")
        default:
            print("error")
        }
    }

}
