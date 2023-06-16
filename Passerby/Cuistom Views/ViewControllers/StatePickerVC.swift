//
//  StatePickerVC.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 03. 19..
//

import RxSwift
import RxCocoa
import UIKit

class StatePickerVC: UIViewController {
    
    var viewModel: StateType!
    private let bag = DisposeBag()
   
    var stateNames = [] as NSMutableArray
//    let states = TaskState().state.map { "\($0.value)" }
    let picker = UIPickerView()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configurePicker()
    }
    
    func configurePicker() {

        picker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picker)
        picker.delegate = self
        picker.dataSource = self

        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            picker.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        viewModel.stateNames
            .subscribe(onNext: { stateNames in
                let mutableStateNames = NSMutableArray(array: stateNames)
                self.stateNames = mutableStateNames
            })
            .disposed(by: bag)
        
        viewModel.defaultStateValue
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { row in
                self.picker.selectRow(row, inComponent: 0, animated: true)
            }).disposed(by: bag)
        
        picker.rx.itemSelected.asObservable()
            .map({ (row: Int, component: Int) in
                return String(row)
            })
            .subscribe(viewModel.selectedStateSubject)
            .disposed(by: bag)
    }
    
        
}

extension StatePickerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stateNames.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return stateNames[row] as? String
    }
    
    
}

